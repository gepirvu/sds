"""
LLM orchestration: rate-limit, token-limit, OpenAI calls, tool dispatch.
"""

from __future__ import annotations

import logging
import time
from typing import Dict, List

from openai import OpenAI
from ratelimit import RateLimitException, limits

import config
from core.tool_handler import handle_tool_calls
from core.rag import retrieve
from core.tools import TOOLS_JSON
from utils.tokenizer import MAX_INPUT_TOKENS, count_tokens

_LOG = logging.getLogger(__name__)
openai = OpenAI()  # uses OPENAI_API_KEY


@limits(calls=100, period=600)  # 100 calls / 10 min
def _ratelimited() -> None:  # decorator side-effect only
    return None


class ChatBot:
    def __init__(self) -> None:
        self._system_prompt = (
            f"You are acting as {config.Settings.NAME}. You are answering questions on "
            f"{config.Settings.NAME}'s website, particularly questions related to "
            f"{config.Settings.NAME}'s career, background, skills and experience. "
            "Your responsibility is to represent them faithfully. "
            "If you don't know an answer, use `record_unknown_question`; "
            "encourage users to share their email and record via `record_user_details`.\n\n"
            "## Summary:\n"
            f"{config.SUMMARY_TEXT}\n\n"
            "## LinkedIn Profile:\n"
            f"{config.LINKEDIN_TEXT}\n\n"
            f"Stay in character as {config.Settings.NAME}."
        )

    # ---------------- PUBLIC ------------- #
    def chat(self, message: str, history: List[Dict]) -> str:
        # --- rate-limit guardrail ---------- #
        try:
            _ratelimited()
        except RateLimitException:
            return (
                "🚦 I'm getting a lot of traffic right now – please try again shortly."
            )

        # --- token guardrail --------------- #
        if count_tokens(message) > MAX_INPUT_TOKENS:
            return "⚠️ Your message is too long. Could you shorten it?"

        # --- build conversation ------------ #
        # --- RAG: get relevant chunks ------- #
        context_chunks = retrieve(message)
        context_block = (
            "\n\n".join(context_chunks)
            if context_chunks
            else "No additional background retrieved."
        )

        # --- build conversation ------------ #
        messages = [
            {"role": "system", "content": self._system_prompt},
            {
                "role": "system",
                "content": (
                    "## Retrieved background (read-only)\n"
                    f"{context_block}\n"
                    "------ End of retrieved context ------"
                ),
            },
        ] + history + [{"role": "user", "content": message}]
        return self._complete(messages)

    # ---------------- INTERNAL ----------- #
       # -------- internals ----------------------------------------------------- #
    def _complete(self, messages):
        """Call OpenAI with retry & tool-handling, then guarantee text."""
        for attempt in range(3):
            try:
                response = openai.chat.completions.create(
                    model=config.Settings.OPENAI_MODEL,
                    messages=messages,
                    tools=TOOLS_JSON,
                    tool_choice="auto",
                )
            except Exception as exc:  # noqa: BLE001
                _LOG.exception("OpenAI error: %s (attempt %s/3)", exc, attempt + 1)
                time.sleep(2 * (attempt + 1))
                continue

            choice = response.choices[0]

            # -- Tool call branch -------------------------------------------
            if choice.finish_reason == "tool_calls":
                tool_msgs = handle_tool_calls(choice.message.tool_calls)
                messages.append(choice.message)
                messages.extend(tool_msgs)
                continue  # loop back with new context

            # -- Normal branch ----------------------------------------------
            text = (choice.message.content or "").strip()

            # -- If still empty, retry once WITHOUT tools -------------------
            if not text:
                _LOG.warning("Empty assistant reply – retrying without tools.")
                try:
                    retry = openai.chat.completions.create(
                        model=config.Settings.OPENAI_MODEL,
                        messages=[m for m in messages if m.get("role") != "tool"],
                        tools=TOOLS_JSON,
                        tool_choice="none",
                    )
                    text = (retry.choices[0].message.content or "").strip()
                except Exception as exc:  # noqa: BLE001
                    _LOG.exception("Retry failed: %s", exc)
                    text = ""

            # -- Final fallback so we never return '' or None ---------------
            if not text:
                text = ("🤖 Sorry, I couldn’t generate a response right now. "
                        "Please try again later.")

            return text

        # We only reach here if all three outer attempts threw exceptions
        return ("🤖 Sorry, I’m having repeated connection issues. "
                "Please try again later.")

