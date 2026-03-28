import firebase_admin
from firebase_admin import credentials, firestore, messaging
import logging
from datetime import datetime
from config import FIREBASE_CREDENTIALS_PATH

logger = logging.getLogger(__name__)


class FirebaseSync:

    def __init__(self):
        if not firebase_admin._apps:
            cred = credentials.Certificate(FIREBASE_CREDENTIALS_PATH)
            firebase_admin.initialize_app(cred)

        self.db = firestore.client()

    def get_existing_job_keys(self) -> list:
        try:
            docs = (
                self.db.collection("jobs")
                .where("isActive", "==", True)
                .select(["title", "company"])
                .stream()
            )

            keys = []
            for doc in docs:
                data = doc.to_dict()
                title = data.get("title", "").lower().strip()
                company = data.get("company", "").lower().strip()
                keys.append(f"{title}_{company}")

            logger.info(f"  [Firebase] Found {len(keys)} existing jobs")
            return keys

        except Exception as e:
            logger.error(f"  [Firebase] Error getting existing keys: {e}")
            return []

    def upload_jobs(self, jobs: list) -> int:
        batch = self.db.batch()
        count = 0

        for job in jobs:
            try:
                doc_ref = self.db.collection("jobs").document()
                job_data = {
                    **job,
                    "id": doc_ref.id,
                    "uploadedAt": firestore.SERVER_TIMESTAMP,
                }
                batch.set(doc_ref, job_data)
                count += 1

                if count % 400 == 0:
                    batch.commit()
                    batch = self.db.batch()

            except Exception as e:
                logger.error(f"  [Firebase] Error preparing job: {e}")

        try:
            batch.commit()
            logger.info(f"  [Firebase] Uploaded {count} jobs")
        except Exception as e:
            logger.error(f"  [Firebase] Batch commit error: {e}")

        return count

    def send_notifications(self, jobs: list):
        try:
            countries = set(j.get("country", "") for j in jobs)
            country_list = ", ".join(countries)

            notification = messaging.Notification(
                title="وظائف جديدة متاحة! 🔍",
                body=f"تم إضافة {len(jobs)} وظيفة جديدة في {country_list}",
            )

            for country in countries:
                if country:
                    topic = f"jobs_{country.lower().replace(' ', '_')}"
                    message = messaging.Message(
                        notification=notification,
                        topic=topic,
                        data={
                            "type": "new_jobs",
                            "country": country,
                            "count": str(len(jobs)),
                        },
                    )
                    try:
                        messaging.send(message)
                        logger.info(f"  [FCM] Sent to topic: {topic}")
                    except Exception as e:
                        logger.error(f"  [FCM] Error sending to {topic}: {e}")

            all_message = messaging.Message(
                notification=notification,
                topic="new_jobs",
                data={
                    "type": "new_jobs",
                    "count": str(len(jobs)),
                },
            )
            messaging.send(all_message)
            logger.info("  [FCM] Sent to topic: new_jobs")

        except Exception as e:
            logger.error(f"  [FCM] Error sending notifications: {e}")

    def update_bot_status(self, jobs_found: int):
        try:
            self.db.collection("bot_status").document("latest").set(
                {
                    "lastRun": firestore.SERVER_TIMESTAMP,
                    "jobsFound": jobs_found,
                    "status": "completed",
                },
                merge=True,
            )
        except Exception as e:
            logger.error(f"  [Firebase] Error updating bot status: {e}")
