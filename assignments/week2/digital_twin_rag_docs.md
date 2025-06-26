# Digital‑Twin Chatbot — Refactor & RAG Extension

---

## 1 Project Structure

```text
project_root/
├─ pyproject.toml         # dependency manifest (uv‑compatible)
├─ .env                   # secrets (OPENAI_API_KEY, PUSHOVER_*)
└─ week2/                 # runtime package / demo entry‑point
   ├─ app.py              # launches Gradio UI
   ├─ core/
   │  ├─ __init__.py
   │  ├─ chatbot.py       # orchestration, guardrails, fallback
   │  ├─ push.py          # Pushover wrapper
   │  ├─ tools.py         # tool fns & JSON specs
   │  ├─ tool_handler.py  # executes LLM tool_calls
   │  ├─ rag.py           # **LangChain‑based RAG layer with Chroma**
   │  └─ rag_manual.py    # manual RAG variant (kept for ref.)
   ├─ ui/
   │  └─ interface.py     # Gradio ChatInterface wrapper
   ├─ utils/
   │  └─ tokenizer.py     # ≈‑token counter (char/4 heuristic)
   ├─ me/
   │  ├─ GP_linkedin.pdf  # résumé PDF (RAG source)
   │  └─ summary.txt      # short bio (prompt only)
   ├─ vector_db/          # **Chroma persistent DB** (auto‑generated)
   ├─ repair_rag.py       # one‑shot builder / DB doctor
   └─ test_chroma.py      # asserts collection is non‑empty
```

---

## 2 Config Highlights (`config.py`)

```python
load_dotenv(override=True)                # loads OPENAI_API_KEY
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
PDF_PATH      = Path("me/GP_linkedin.pdf")
LINKEDIN_TEXT = _load_pdf_text(PDF_PATH)   # ≈ 7 k chars
# summary.txt is *prompt‑only*; PDF feeds the RAG pipeline.
```

---

## 3 Retrieval‑Augmented Generation (`core/rag.py`)

| Component       | Setting                                                  |
| --------------- | -------------------------------------------------------- |
| Splitter        | `RecursiveCharacterTextSplitter(600/100)`                |
| Embeddings      | `OpenAIEmbeddings()` (text‑embedding‑3‑small)            |
| Vector DB       | `Chroma` persisted in `vector_db/` (`resume` collection) |
| Build behaviour | Auto‑rebuild if collection missing/empty                 |
| Public API      | `retrieve(query: str, k: int) -> List[str]`              |

---

## 4 Chat Orchestration (`core/chatbot.py`)

- **Rate‑limit** – `@limits(calls=100, period=600)`
- **Token guard** – rejects input > 1 000 tokens
- **RAG injection** – prepends top‑K chunks as read‑only context
- **Tool loop** – handles and logs OpenAI tool calls via `tool_handler`
- **Robust fallback**
  1. If model returns empty text, retry once with `tool_choice="none"`.
  2. If still empty, return static apology – *never* `None`.

---

## 5 Tools (`core/tools.py`)

| Function                  | Purpose                                            |
| ------------------------- | -------------------------------------------------- |
| `record_user_details`     | Push + log interested user (email regex validated) |
| `record_unknown_question` | Push + log when LLM cannot answer                  |

Tools are registered in a `TOOL_REGISTRY` dictionary – no `globals()` risk.

---

## 6 Running & Testing

### Install deps (PowerShell)

```powershell
# venv already activated
uv pip sync                      # installs versions from pyproject.toml
```

### Start Gradio UI

```powershell
python week2\app.py              # then open http://127.0.0.1:7861
```

### Unit checks

```powershell
python week2\test_chroma.py      # expects > 10 chunks
python -c "from core.chatbot import ChatBot; print(ChatBot().chat('hi', []))"
```

### Rebuild vector DB (if empty/corrupt)

```powershell
python week2\repair_rag.py       # wipes & re‑embeds résumé
```

---

## 7 Key Improvements

- **Modular design** – clear separation of UI, core logic, utils.
- **Secure tool dispatch** – registry pattern replaces `globals()`.
- **Guardrails** – rate‑limit, token‑limit, robust fallbacks.
- **RAG layer** – LangChain‑based, mirroring instructor template.
- **Logging** – tool calls, finish\_reason, retries, RAG chunks.
- **Helper scripts** – DB diagnostics & CI‑friendly tests.

---

## 8 Next Steps

1. Migrate retriever to `invoke()` API (deprecation removal).
2. Dockerfile + GitHub CI for automated smoke tests.
3. Optional hierarchical RAG for larger corpora.
4. UI polish (source‑toggle, chunk‑preview in debug mode).

---

© 2025 George Pirvu — Digital‑Twin Chatbot with RAG

