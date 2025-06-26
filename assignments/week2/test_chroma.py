"""
Quick diagnostic for the résumé RAG database.
Reports whether the persistent Chroma store exists and
how many résumé chunks (embeddings) are present.

Exit codes
----------
0  – Success, collection found and non-empty
1  – Chroma DB directory missing
2  – Collection missing or empty
"""

from __future__ import annotations

import sys
from pathlib import Path

import chromadb

# --- configuration must match core/rag.py -----------------------------------
CHROMA_DIR = Path(__file__).resolve().parent / "vector_db"
COLLECTION_NAME = "resume"
# ----------------------------------------------------------------------------

if not CHROMA_DIR.exists():
    print(f"❌ Chroma directory not found: {CHROMA_DIR}")
    sys.exit(1)

client = chromadb.PersistentClient(path=str(CHROMA_DIR))

try:
    coll = client.get_collection(COLLECTION_NAME)
except ValueError:
    print(f"❌ Collection '{COLLECTION_NAME}' not found inside {CHROMA_DIR}")
    sys.exit(2)

num_docs = coll.count()
if num_docs == 0:
    print(f"⚠️  Collection '{COLLECTION_NAME}' is empty (0 embeddings).")
    sys.exit(2)

print(f"✅ Collection '{COLLECTION_NAME}' contains {num_docs} embedded chunks.")

# Optional: show a couple of stored snippets for visual sanity
sample_ids = [f"doc-{i}" for i in range(min(3, num_docs))]
sample = coll.get(ids=sample_ids, include=["documents"])
for i, (doc_id, text) in enumerate(zip(sample["ids"], sample["documents"]), 1):
    preview = text.replace("\n", " ")[:100] + "…"
    print(f"   {i}. {doc_id:<8} {preview}")

sys.exit(0)