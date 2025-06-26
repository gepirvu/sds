"""
Gradio wrapper – stateless; history lives on the browser.
"""

import logging

import gradio as gr

from core.chatbot import ChatBot

_LOG = logging.getLogger(__name__)
_bot = ChatBot()


def _chat_wrapper(message, history):
    try:
        # Avoid empty prompt on Gradio's first "heartbeat"
        answer = _bot.chat(message or " ", history)
        print(message)
        print(answer)
    except Exception as exc:  # noqa: BLE001
        _LOG.exception("Unexpected error: %s", exc)
        answer = "😢 An unexpected server error occurred."

    if not answer:
        answer = "⚠️  No response – please try again."

    return {"role": "assistant", "content": answer}


def launch_gradio():
    gr.ChatInterface(_chat_wrapper, type="messages").launch()