"""
Executes OpenAI tool calls, returns tool-messages.
"""

from __future__ import annotations

import json
import logging
from typing import Dict, List

from core.tools import TOOL_REGISTRY

_LOG = logging.getLogger(__name__)


def handle_tool_calls(tool_calls) -> List[Dict]:
    results = []

    for call in tool_calls:
        name = call.function.name
        args = json.loads(call.function.arguments)

        fn = TOOL_REGISTRY.get(name)
        if not fn:
            _LOG.warning("Unknown tool '%s' – ignored.", name)
            continue

        try:
            payload = fn(**args)
        except Exception as exc:  # noqa: BLE001
            _LOG.exception("Tool '%s' failed: %s", name, exc)
            payload = {"error": str(exc)}

        results.append(
            {
                "role": "tool",
                "tool_call_id": call.id,
                "content": json.dumps(payload),
            }
        )

    return results
