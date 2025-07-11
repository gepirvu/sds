"""
Approximate token counter – **no external packages**.

OpenAI tokens average ~4 chars each, so strlen/4 is a good upper bound.
"""

MAX_INPUT_TOKENS = 1_000


def count_tokens(text: str) -> int:
    return (len(text) // 4) + 1  # rough but safe