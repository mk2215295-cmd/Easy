import os
from dotenv import load_dotenv

load_dotenv()

# Firebase
FIREBASE_CREDENTIALS_PATH = os.getenv("FIREBASE_CREDENTIALS_PATH", "firebase-credentials.json")

# Jooble API
JOOBLE_API_KEY = os.getenv("JOOBLE_API_KEY", "")

# Target countries and search keywords
EU_COUNTRIES = [
    {"name": "Germany", "code": "de", "search_location": "Germany"},
    {"name": "France", "code": "fr", "search_location": "France"},
    {"name": "Netherlands", "code": "nl", "search_location": "Netherlands"},
    {"name": "Italy", "code": "it", "search_location": "Italy"},
    {"name": "Spain", "code": "es", "search_location": "Spain"},
    {"name": "Sweden", "code": "se", "search_location": "Sweden"},
    {"name": "Austria", "code": "at", "search_location": "Austria"},
    {"name": "Belgium", "code": "be", "search_location": "Belgium"},
    {"name": "Poland", "code": "pl", "search_location": "Poland"},
]

SEARCH_KEYWORDS = [
    "visa sponsorship",
    "work permit",
    "international workers",
    "relocation package",
]

# Scheduler
SCRAPE_INTERVAL_HOURS = 6

# Job filtering
VISA_KEYWORDS = [
    "visa sponsorship",
    "visa sponsor",
    "work permit",
    "work permit sponsor",
    "relocation support",
    "relocation package",
    "international candidates",
    "sponsor visa",
    "permit to work",
]

CURRENCY_MAP = {
    "de": "EUR", "fr": "EUR", "nl": "EUR", "it": "EUR",
    "es": "EUR", "at": "EUR", "be": "EUR",
    "se": "SEK", "pl": "PLN",
}

FLAG_MAP = {
    "de": "🇩🇪", "fr": "🇫🇷", "nl": "🇳🇱", "it": "🇮🇹",
    "es": "🇪🇸", "se": "🇸🇪", "at": "🇦🇹", "be": "🇧🇪", "pl": "🇵🇱",
}
