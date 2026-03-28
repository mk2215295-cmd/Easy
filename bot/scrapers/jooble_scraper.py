import requests
import logging
from datetime import datetime
from config import JOOBLE_API_KEY, CURRENCY_MAP, FLAG_MAP

logger = logging.getLogger(__name__)


class JoobleScraper:
    BASE_URL = "https://jooble.org/api"

    def scrape(self, country: dict) -> list:
        if not JOOBLE_API_KEY or JOOBLE_API_KEY == "YOUR_JOOBLE_API_KEY_HERE":
            logger.warning("  [Jooble] API key not configured, skipping")
            return []

        jobs = []
        keywords = ["visa sponsorship", "work permit"]

        for keyword in keywords:
            try:
                payload = {
                    "keywords": keyword,
                    "location": country["search_location"],
                    "radius": 100,
                    "page": 1,
                }

                response = requests.post(
                    f"{self.BASE_URL}/{JOOBLE_API_KEY}",
                    json=payload,
                    headers={"Content-Type": "application/json"},
                    timeout=30,
                )

                if response.status_code == 200:
                    data = response.json()
                    for job in data.get("jobs", []):
                        jobs.append(self._convert_job(job, country))
                else:
                    logger.warning(f"  [Jooble] Status {response.status_code}")

            except requests.RequestException as e:
                logger.error(f"  [Jooble] Request error: {e}")

        return jobs

    def _convert_job(self, job: dict, country: dict) -> dict:
        code = country["code"]
        return {
            "title": job.get("title", ""),
            "company": job.get("company", ""),
            "location": job.get("location", country["search_location"]),
            "country": country["name"].lower(),
            "countryCode": code,
            "countryFlag": FLAG_MAP.get(code, "🌍"),
            "description": job.get("snippet", ""),
            "requirements": "",
            "salary": self._extract_salary(job.get("salary", "")),
            "currency": CURRENCY_MAP.get(code, "EUR"),
            "workHours": "40",
            "isHousingProvided": False,
            "isVisaSponsor": True,
            "languageRequired": "English",
            "jobType": job.get("type", "Full-time"),
            "source": "Jooble",
            "sourceUrl": job.get("link", ""),
            "postedDate": datetime.now(datetime.timezone.utc).isoformat(),
            "isActive": True,
            "benefits": [],
        }

    def _extract_salary(self, salary_str: str) -> str:
        if not salary_str:
            return "0"
        import re
        numbers = re.findall(r"\d[\d,]*", str(salary_str))
        return numbers[0].replace(",", "") if numbers else "0"
