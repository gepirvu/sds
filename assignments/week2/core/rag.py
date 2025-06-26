"""
LangChain-based RAG layer that mirrors the instructor’s code:

• CharacterTextSplitter  (1000/200)
• OpenAIEmbeddings       (default model)
• Chroma vector store    (persist_directory="vector_db")
• Exposes retrieve(query, k) -> list[str]

If the collection is empty it builds it; otherwise it re-uses it.
"""

from __future__ import annotations

import logging
import os
from pathlib import Path
from typing import List

from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_openai import OpenAIEmbeddings
from langchain_chroma import Chroma

import config

_LOG = logging.getLogger(__name__)

# Same name/location the teacher used --------------------------
DB_NAME = "vector_db"                       # folder on disk
DB_DIR = Path(__file__).resolve().parent.parent / DB_NAME
COLLECTION = "resume"
TOP_K = 4

# --------------------------------------------------------------


def _vectorstore() -> Chroma:
    """
    Create or load the Chroma vector store with LangChain’s helper.
    If the collection is empty, rebuild it from résumé + summary.
    """
    embeddings = OpenAIEmbeddings()         # teacher uses defaults
    splitter = RecursiveCharacterTextSplitter(chunk_size=600, chunk_overlap=100)

    if not DB_DIR.exists():
        DB_DIR.mkdir(exist_ok=True)

    # Try loading an existing store
    try:
        vs = Chroma(
            collection_name=COLLECTION,
            embedding_function=embeddings,
            persist_directory=str(DB_DIR),
        )
        if vs._collection.count() > 0:
            _LOG.info("Loaded existing Chroma collection (%s chunks).",
                      vs._collection.count())
            return vs
        _LOG.warning("Chroma collection is empty – rebuilding.")
    except Exception:  # collection doesn’t exist or other error
        pass

    # Build from scratch
    full_text = f"{config.SUMMARY_TEXT}\n\n{config.LINKEDIN_TEXT}"
    docs = splitter.create_documents([full_text])
    vs = Chroma.from_documents(
        documents=docs,
        embedding=embeddings,
        persist_directory=str(DB_DIR),
        collection_name=COLLECTION,
    )
    _LOG.info("Created Chroma collection with %s chunks.",
              vs._collection.count())
    return vs


_vectorstore_cached = _vectorstore()
_retriever = _vectorstore_cached.as_retriever(search_kwargs={"k": TOP_K})


def retrieve(query: str, k: int = TOP_K) -> List[str]:
    """Return top-k chunk strings relevant to *query*."""
    if not query.strip():
        return []
    try:
        docs = _retriever.get_relevant_documents(query)
        return [d.page_content for d in docs][:k]
    except Exception as exc:  # noqa: BLE001
        _LOG.exception("LangChain/Chroma retrieval failed: %s", exc)
        return []