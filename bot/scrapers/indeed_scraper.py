import requests
from bs4 import BeautifulSoup
import logging
from datetime import datetime
from config import CURRENCY_MAP, FLAG_MAP
import time
import random
from fake_useragent import UserAgent

logger = logging.getLogger(__name__)


class IndeedScraper:
    BASE_URLS = {
        "de": "https://de.indeed.com",
        "fr": "https://www.indeed.fr",
        "nl": "https://nl.indeed.com",
        "it": "https://it.indeed.com",
        "es": "https://www.indeed.es",
        "se": "https://se.indeed.com",
        "at": "https://at.indeed.com",
        "be": "https://be.indeed.com",
        "pl": "https://pl.indeed.com",
    }

    def scrape(self, country: dict) -> list:
        jobs = []
        code = country["code"]
        base_url = self.BASE_URLS.get(code)

        if not base_url:
            return []

        search_queries = ["visa sponsorship", "work permit"]

        for query in search_queries:
            try:
                time.sleep(random.uniform(2, 5))

                ua = UserAgent()
                headers = {
                    "User-Agent": ua.random,
                    "Accept-Language": "en-US,en;q=0.9",
                }

                url = f"{base_url}/jobs"
                params = {
                    "q": query,
                    "l": country["search_location"],
                    "fromage": 7,
                }

                response = requests.get(
                    url, params=params, headers=headers, timeout=30
                )

                if response.status_code == 200:
                    page_jobs = self._parse_jobs(response.text, country)
                    jobs.extend(page_jobs)
                    logger.info(f"  [Indeed/{code}] Found {len(page_jobs)} jobs for '{query}'")
                else:
                    logger.warning(f"  [Indeed/{code}] Status {response.status_code}")

            except requests.RequestException as e:
                logger.error(f"  [Indeed/{code}] Error: {e}")

        return jobs

    def _parse_jobs(self, html: str, country: dict) -> list:
        jobs = []
        soup = BeautifulSoup(html, "lxml")
        code = country["code"]

        job_cards = soup.find_all("div", class_=lambda c: c and "job_seen_beacon" in str(c).lower())

        if not job_cards:
            job_cards = soup.find_all("a", class_=lambda c: c and "jcs-JobTitle" in str(c).lower())

        for card in job_cards[:20]:
            try:
                title_elem = card.find("h2") or card.find("a")
                title = title_elem.get_text(strip=True) if title_elem else ""

                company_elem = card.find("span", class_=lambda c: c and "company" in str(c).lower())
                company = company_elem.get_text(strip=True) if company_elem else ""

                location_elem = card.find("div", class_=lambda c: c and "companyLocation" in str(c).lower())
                location = location_elem.get_text(strip=True) if location_elem else country["search_location"]

                snippet_elem = card.find("div", class_=lambda c: c and "job-snippet" in str(c).lower())
                description = snippet_elem.get_text(strip=True) if snippet_elem else ""

                link_elem = card.find("a", href=True)
                link = ""
                if link_elem:
                    href = link_elem["href"]
                    link = f"{self.BASE_URLS.get(code, '')}{href}" if href.startswith("/") else href

                salary_elem = card.find("div", class_=lambda c: c and "salary" in str(c).lower())
                salary_text = salary_elem.get_text(strip=True) if salary_elem else ""

                if title:
                    jobs.append({
                        "title": title,
                        "company": company,
                        "location": location,
                        "country": country["name"].lower(),
                        "countryCode": code,
                        "countryFlag": FLAG_MAP.get(code, "🌍"),
                        "description": description,
                        "requirements": "",
                        "salary": self._extract_salary(salary_text),
                        "currency": CURRENCY_MAP.get(code, "EUR"),
                        "workHours": "40",
                        "isHousingProvided": False,
                        "isVisaSponsor": True,
                        "languageRequired": "English",
                        "jobType": "Full-time",
                        "source": "Indeed",
                        "sourceUrl": link,
                        "postedDate": datetime.now(datetime.timezone.utc).isoformat(),
                        "isActive": True,
                        "benefits": [],
                    })

            except Exception as e:
                logger.debug(f"  [Indeed] Parse error: {e}")
                continue

        return jobs

    def _extract_salary(self, salary_str: str) -> str:
        if not salary_str:
            return "0"
        import re
        numbers = re.findall(r"\d[\d,]*", salary_str)
        return numbers[0].replace(",", "") if numbers else "0"
