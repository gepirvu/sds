import json, config
from openai import OpenAI
client = OpenAI()

messages = [
    {"role": "system", "content": "You are helpful."},
    {"role": "user", "content": "Who is George Pirvu?"}
]

resp = client.chat.completions.create(
    model=config.Settings.OPENAI_MODEL,
    messages=messages,
    tool_choice="none"        # forbid tools
)

print("finish_reason ->", resp.choices[0].finish_reason)
print("content       ->", repr(resp.choices[0].message.content))
print(json.dumps(resp.model_dump(), indent=2)[:1000], "…")