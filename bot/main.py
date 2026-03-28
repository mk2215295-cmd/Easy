from scrapers.jooble_scraper import JoobleScraper
from scrapers.indeed_scraper import IndeedScraper
from scrapers.eu_companies import EUCompaniesScraper
from filters import JobFilter
from deduplicator import Deduplicator
from firebase_sync import FirebaseSync
from config import SCRAPE_INTERVAL_HOURS, EU_COUNTRIES
from datetime import datetime
import logging
import os

IS_GITHUB_ACTIONS = os.getenv("GITHUB_ACTIONS") == "true"

log_handlers = [logging.StreamHandler()]
if not IS_GITHUB_ACTIONS:
    log_handlers.append(logging.FileHandler("bot.log"))

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    handlers=log_handlers,
)
logger = logging.getLogger(__name__)


def run_scrape_cycle():
    logger.info("=" * 60)
    logger.info(f"بدء دورة البحث - {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    logger.info("=" * 60)

    firebase = FirebaseSync()
    job_filter = JobFilter()
    dedup = Deduplicator(firebase)

    scrapers = [
        ("Jooble", JoobleScraper()),
        ("Indeed", IndeedScraper()),
        ("EU Companies", EUCompaniesScraper()),
    ]

    all_new_jobs = []

    for country in EU_COUNTRIES:
        logger.info(f"\n--- البحث في {country['name']} ---")

        for scraper_name, scraper in scrapers:
            try:
                logger.info(f"  [{scraper_name}] جاري البحث...")
                jobs = scraper.scrape(country)
                logger.info(f"  [{scraper_name}] وُجد {len(jobs)} وظيفة")

                filtered = job_filter.filter_visa_jobs(jobs)
                logger.info(f"  [{scraper_name}] بعد الفلترة: {len(filtered)} وظيفة")

                all_new_jobs.extend(filtered)

            except Exception as e:
                logger.error(f"  [{scraper_name}] خطأ: {e}")

    unique_jobs = dedup.remove_duplicates(all_new_jobs)
    logger.info(f"\nإجمالي الوظائف الفريدة: {len(unique_jobs)}")

    if unique_jobs:
        new_count = firebase.upload_jobs(unique_jobs)
        logger.info(f"تم رفع {new_count} وظيفة جديدة إلى Firebase")

        firebase.send_notifications(unique_jobs)
        logger.info("تم إرسال الإشعارات")
    else:
        logger.info("لا توجد وظائف جديدة")

    firebase.update_bot_status(len(unique_jobs))
    logger.info(f"انتهت الدورة - {datetime.now().strftime('%H:%M:%S')}\n")


def main():
    logger.info("🤖 Easy Work AI Job Bot Started")
    logger.info(f"الوضع: {'GitHub Actions' if IS_GITHUB_ACTIONS else 'Local Server'}")

    run_scrape_cycle()

    if IS_GITHUB_ACTIONS:
        logger.info("✅ انتهت دورة GitHub Actions")
        return

    logger.info(f"سيتم البحث كل {SCRAPE_INTERVAL_HOURS} ساعات")
    logger.info(f"البحث التالي بعد {SCRAPE_INTERVAL_HOURS} ساعات")

    from apscheduler.schedulers.blocking import BlockingScheduler

    scheduler = BlockingScheduler()
    scheduler.add_job(
        run_scrape_cycle,
        "interval",
        hours=SCRAPE_INTERVAL_HOURS,
        id="job_scrape_cycle",
    )

    try:
        scheduler.start()
    except (KeyboardInterrupt, SystemExit):
        logger.info("تم إيقاف البوت")


if __name__ == "__main__":
    main()
