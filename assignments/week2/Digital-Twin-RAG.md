Digital Twin Chatbot — Refactor & RAG Extension

1 Project Structure

week2/
├─ app.py               # entry‑point → launches Gradio
├─ core/
│  ├─ __init__.py
│  ├─ chatbot.py        # orchestration, rate‑limit, token guard, fallback
│  ├─ push.py           # Pushover wrapper
│  ├─ tools.py          # tool implementations + JSON specs
│  ├─ tool_handler.py   # executes LLM tool_calls
│  ├─ rag.py            # **LangChain‑based RAG layer with Chroma**
│  └─ rag_manual.py     # (manual RAG variant, kept for reference)
├─ utils/
│  └─ tokenizer.py      # simple char/4 ≈ token counter
├─ ui/
│  └─ interface.py      # Gradio ChatInterface wrapper
├─ me/
│  ├─ GP_linkedin.pdf   # résumé PDF
│  └─ summary.txt       # short bio summary (prompt only)
├─ vector_db/           # **Chroma persistent DB** (auto‑generated)
├─ repair_rag.py        # one‑shot builder / DB doctor
└─ test_chroma.py       # unit check: non‑empty collection

project_root/
├─ pyproject.toml       # dependency manifest (uv‑compatible)
└─ .env                 # secrets (OPENAI_API_KEY, PUSHOVER_*)

2 Config Highlights (config.py)

load_dotenv(override=True)                # loads OPENAI_API_KEY
OPENAI_MODEL = os.getenv("OPENAI_MODEL", "gpt-4o-mini")
PDF_PATH      = Path("me/GP_linkedin.pdf")
...
LINKEDIN_TEXT = _load_pdf_text(PDF_PATH)   # ≈ 7 k chars

The summary file is prompt‑only; RAG indexes PDF text only.

3 Retrieval‑Augmented Generation (core/rag_lc.py)

Splitter: RecursiveCharacterTextSplitter(chunk_size=600, overlap=100)

Embeddings: OpenAIEmbeddings() (text‑embedding‑3‑small default)

Vector store: Chroma persisted in vector_db/ under collection name resume.

Build happens once; if collection is empty at load‑time it is rebuilt automatically.

Public API: retrieve(query:str,k:int)->List[str] used by chatbot.py.

4 Chat Orchestration (core/chatbot.py)

Rate‑limit: @limits(calls=100, period=600) → 100 calls/10 min.

Token guard: rough 1 000‑token cap via utils.tokenizer.

RAG injection: top‑K (default 4) chunks are prepended as a read‑only system message.

Tool handling: loop executes OpenAI tool_calls via tool_handler.

Robust fallback:

If OpenAI returns empty content, retry once with tool_choice="none" and no tool messages.

If still empty, return a static apology → never returns None or "".

5 Tools (core/tools.py)

Tool

Purpose

record_user_details(email,name,notes)

Push notification + email validation (regex)

record_unknown_question(question)

Push notification when LLM can’t answer

Registered via @register_tool, stored in TOOL_REGISTRY, dispatched securely—no globals().

6 Running & Testing

Installation (inside venv)

uv pip install -r <(python scripts/export_deps.py)   # or uv pip sync

Start the server

python app.py

Navigate to http://127.0.0.1:7861.

Unit tests

python test_chroma.py                 # expects  >10 chunks
python -c "from core.chatbot import ChatBot; print(ChatBot().chat('hi', []))"

Repair vector DB (if empty/corrupt)

python repair_rag.py                  # rebuilds and prints chunk count

7 Key Improvements vs. Original Code

Structured modules – clear separation: core, ui, utils.

Secure tool dispatch – registry pattern replaces globals().

Rate & token guardrails – protects cost and abuse.

Robust fallback logic – chatbot never returns None; UI never shows “⚠️ No response”.

LangChain RAG – mirrors instructor’s template, but is optional; manual variant kept.

Logging – tool calls, LLM finish‑reasons, retry paths, RAG chunks (toggle).*

Testing scripts – test_chroma.py, repair_rag.py, instrumentation snippets.

8 Next Steps / Improvements

Upgrade LangChain retriever to new .invoke() API (deprecation warning).

Dockerise for one‑command deployment.

CI pipeline – run test_chroma.py + a chat smoke‑test on every PR.

Hierarchical RAG – add second‑tier summarisation when chunk set > K.