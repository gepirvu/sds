import logging
import requests

from config import Settings

_LOG = logging.getLogger(__name__)
_PUSHOVER_URL = "https://api.pushover.net/1/messages.json"


def push(message: str) -> None:
    """
    Fire-and-forget push notification.
    Failure is logged – never crashes the chat.
    """
    if not (Settings.PUSHOVER_USER and Settings.PUSHOVER_TOKEN):
        _LOG.warning("Pushover not configured; skipping push.")
        return

    try:
        requests.post(
            _PUSHOVER_URL,
            data={
                "user": Settings.PUSHOVER_USER,
                "token": Settings.PUSHOVER_TOKEN,
                "message": message,
            },
            timeout=5,
        )
        _LOG.info("Pushover sent: %s", message)
    except requests.RequestException as exc:
        _LOG.exception("Pushover failed: %s", exc)
