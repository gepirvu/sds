"""
Tool callbacks, JSON specs, secure registry.
"""

from __future__ import annotations

import json
import logging
import re
from typing import Any, Callable, Dict

from core.push import push

_LOG = logging.getLogger(__name__)
EMAIL_RE = re.compile(r"^[^@]+@[^@]+\.[^@]+$")

# ---------------- Registry ---------------- #
TOOL_REGISTRY: Dict[str, Callable[..., Dict[str, Any]]] = {}


def register_tool(fn: Callable[..., Dict[str, Any]]):
    TOOL_REGISTRY[fn.__name__] = fn
    return fn


# ---------------- Tools ------------------- #
@register_tool
def record_user_details(
    *,
    email: str,
    name: str = "Name not provided",
    notes: str = "not provided",
) -> dict:
    if not EMAIL_RE.match(email):
        raise ValueError("Invalid email format.")

    push(f"Interest from {name} – {email}. Notes: {notes}")
    return {"status": "ok"}


@register_tool
def record_unknown_question(*, question: str) -> dict:
    push(f"Unanswered question recorded: {question}")
    return {"status": "ok"}


# ------------- JSON specs ----------------- #
record_user_details_json = {
    "name": "record_user_details",
    "description": (
        "Use this tool to record that a user is interested in being in touch "
        "and provided an email address."
    ),
    "parameters": {
        "type": "object",
        "properties": {
            "email": {"type": "string", "description": "User’s email address."},
            "name": {"type": "string", "description": "User’s name."},
            "notes": {"type": "string", "description": "Extra context."},
        },
        "required": ["email"],
        "additionalProperties": False,
    },
}

record_unknown_question_json = {
    "name": "record_unknown_question",
    "description": (
        "Always use this tool to record any question that could not be answered."
    ),
    "parameters": {
        "type": "object",
        "properties": {
            "question": {"type": "string", "description": "The unanswered question."}
        },
        "required": ["question"],
        "additionalProperties": False,
    },
}

TOOLS_JSON = [
    {"type": "function", "function": record_user_details_json},
    {"type": "function", "function": record_unknown_question_json},
]