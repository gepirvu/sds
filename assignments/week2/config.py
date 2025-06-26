"""
Central configuration and one-shot data loading.
"""

import os
from pathlib import Path

from dotenv import load_dotenv
from pypdf import PdfReader

load_dotenv(override=True)


class Settings:
    # ---- Environment -------------------------------------------------------
    OPENAI_MODEL: str = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
    PUSHOVER_USER: str | None = os.getenv("PUSHOVER_USER")
    PUSHOVER_TOKEN: str | None = os.getenv("PUSHOVER_TOKEN")

    # ---- Static data -------------------------------------------------------
    NAME: str = "George Pirvu"
    PDF_PATH: Path = Path(os.getenv("PDF_PATH", "me/GP_linkedin.pdf"))
    SUMMARY_PATH: Path = Path(os.getenv("SUMMARY_PATH", "me/summary.txt"))


def _load_pdf_text(pdf_path: Path) -> str:
    reader = PdfReader(pdf_path)
    return "".join(page.extract_text() or "" for page in reader.pages)


def _load_summary(txt_path: Path) -> str:
    with txt_path.open(encoding="utf-8") as fp:
        return fp.read()


LINKEDIN_TEXT: str = _load_pdf_text(Settings.PDF_PATH)
SUMMARY_TEXT: str = _load_summary(Settings.SUMMARY_PATH)