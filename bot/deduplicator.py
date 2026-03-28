import logging
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)


class Deduplicator:

    def __init__(self, firebase_sync):
        self.firebase = firebase_sync
        self._existing_keys = set()

    def _generate_key(self, job: dict) -> str:
        title = job.get("title", "").lower().strip()
        company = job.get("company", "").lower().strip()
        return f"{title}_{company}"

    def remove_duplicates(self, jobs: list) -> list:
        existing = self.firebase.get_existing_job_keys()
        self._existing_keys = set(existing)

        unique = []
        seen = set()

        for job in jobs:
            key = self._generate_key(job)

            if key in seen:
                continue

            if key in self._existing_keys:
                continue

            seen.add(key)
            unique.append(job)

        logger.info(f"  [Dedup] {len(jobs)} -> {len(unique)} (removed {len(jobs) - len(unique)})")
        return unique
