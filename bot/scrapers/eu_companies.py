import requests
from bs4 import BeautifulSoup
import logging
from datetime import datetime
from config import CURRENCY_MAP, FLAG_MAP
import time
import random

logger = logging.getLogger(__name__)


class EUCompaniesScraper:
    COMPANIES = [
        {
            "name": "BMW Group",
            "url": "https://www.bmwgroup.jobs/de/en.html",
            "country": "germany",
            "code": "de",
        },
        {
            "name": "Siemens",
            "url": "https://jobs.siemens.com/en/search-jobs",
            "country": "germany",
            "code": "de",
        },
        {
            "name": "SAP",
            "url": "https://jobs.sap.com/search/",
            "country": "germany",
            "code": "de",
        },
        {
            "name": "ING Group",
            "url": "https://www.ing.jobs/Netherlands/Vacancies.htm",
            "country": "netherlands",
            "code": "nl",
        },
        {
            "name": "Philips",
            "url": "https://www.philips.com/a-w/about/careers.html",
            "country": "netherlands",
            "code": "nl",
        },
        {
            "name": "Spotify",
            "url": "https://www.lifeatspotify.com/jobs",
            "country": "sweden",
            "code": "se",
        },
        {
            "name": "Klarna",
            "url": "https://jobs.klarna.com/en/jobs/",
            "country": "sweden",
            "code": "se",
        },
        {
            "name": "Revolut",
            "url": "https://www.revolut.com/careers/",
            "country": "germany",
            "code": "de",
        },
    ]

    def scrape(self, country: dict) -> list:
        jobs = []
        code = country["code"]

        companies = [c for c in self.COMPANIES if c["code"] == code]

        if not companies:
            return []

        for company_info in companies:
            try:
                time.sleep(random.uniform(3, 6))

                headers = {
                    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36",
                    "Accept-Language": "en-US,en;q=0.9",
                }

                response = requests.get(
                    company_info["url"],
                    headers=headers,
                    timeout=30,
                )

                if response.status_code == 200:
                    page_jobs = self._parse_company_jobs(
                        response.text, company_info, country
                    )
                    jobs.extend(page_jobs)
                    logger.info(
                        f"  [Companies/{company_info['name']}] Found {len(page_jobs)} jobs"
                    )
                else:
                    logger.warning(
                        f"  [Companies/{company_info['name']}] Status {response.status_code}"
                    )

            except requests.RequestException as e:
                logger.error(f"  [Companies/{company_info['name']}] Error: {e}")

        return jobs

    def _parse_company_jobs(self, html: str, company_info: dict, country: dict) -> list:
        jobs = []
        soup = BeautifulSoup(html, "lxml")
        code = country["code"]

        selectors = [
            "div.job-listing",
            "li.job-item",
            "div.careers-listing__item",
            "a.job-link",
            "tr.data-row",
            "div.job-card",
        ]

        for selector in selectors:
            items = soup.select(selector)
            if items:
                for item in items[:10]:
                    try:
                        title = ""
                        for tag in ["h2", "h3", "h4", "a", "span"]:
                            elem = item.find(tag)
                            if elem:
                                title = elem.get_text(strip=True)
                                if len(title) > 5:
                                    break

                        link = ""
                        a_tag = item.find("a", href=True)
                        if a_tag:
                            link = a_tag["href"]
                            if link.startswith("/"):
                                from urllib.parse import urlparse
                                base = urlparse(company_info["url"])
                                link = f"{base.scheme}://{base.netloc}{link}"

                        location = item.find(
                            string=lambda s: s and any(
                                c in s.lower()
                                for c in [country["name"].lower(), "remote", "hybrid"]
                            )
                        )
                        location_str = str(location).strip() if location else country["search_location"]

                        if title and len(title) > 5:
                            visa_keywords = ["visa", "sponsor", "international", "relocation"]
                            has_visa = any(
                                kw in title.lower() or kw in (item.get_text().lower())
                                for kw in visa_keywords
                            )

                            jobs.append({
                                "title": title,
                                "company": company_info["name"],
                                "location": location_str,
                                "country": country["name"].lower(),
                                "countryCode": code,
                                "countryFlag": FLAG_MAP.get(code, "🌍"),
                                "description": f"Job at {company_info['name']}",
                                "requirements": "",
                                "salary": "0",
                                "currency": CURRENCY_MAP.get(code, "EUR"),
                                "workHours": "40",
                                "isHousingProvided": False,
                                "isVisaSponsor": has_visa,
                                "languageRequired": "English",
                                "jobType": "Full-time",
                                "source": company_info["name"],
                                "sourceUrl": link,
                                "postedDate": datetime.now(datetime.timezone.utc).isoformat(),
                                "isActive": True,
                                "benefits": [],
                            })

                    except Exception as e:
                        logger.debug(f"  [Companies] Parse error: {e}")
                        continue

                break

        return jobs
