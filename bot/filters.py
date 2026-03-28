import logging
from config import VISA_KEYWORDS

logger = logging.getLogger(__name__)


class JobFilter:

    def filter_visa_jobs(self, jobs: list) -> list:
        filtered = []

        for job in jobs:
            if self._has_visa_support(job):
                job["isVisaSponsor"] = True
                filtered.append(job)
            elif job.get("isVisaSponsor"):
                filtered.append(job)

        return filtered

    def _has_visa_support(self, job: dict) -> bool:
        text = " ".join([
            job.get("title", ""),
            job.get("description", ""),
            job.get("requirements", ""),
        ]).lower()

        return any(kw in text for kw in VISA_KEYWORDS)

    def filter_by_country(self, jobs: list, country_code: str) -> list:
        return [j for j in jobs if j.get("countryCode") == country_code]

    def filter_by_job_type(self, jobs: list, job_type: str) -> list:
        return [j for j in jobs if j.get("jobType", "").lower() == job_type.lower()]

    def filter_active_only(self, jobs: list) -> list:
        return [j for j in jobs if j.get("isActive", True)]
