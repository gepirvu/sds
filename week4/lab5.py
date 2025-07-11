#!/usr/bin/env python3
"""
Lab 5 - Context Engineering
We want to develop several types of Memory:
1. Long Term Memory - graph: A knowledge graph as a persistent store of entities
2. Long Term Memory - knowledge: A RAG database of Q&A and any other useful information
3. Permanent context: Summary and linkedin profile included in everything
4. FAQ: A list of questions and answers

Websites where you can find MCP Servers:
- https://mcp.so
- https://glama.ai
- https://smithery.ai
"""

from dotenv import load_dotenv
from agents.mcp import MCPServerStdio
import sqlite3
import asyncio
import os

load_dotenv(override=True)

# Create directories if they don't exist
os.makedirs("./twin/memory/knowledge", exist_ok=True)

async def setup_memory_graph():
    """Setup Knowledge Graph MCP server built on libsql"""
    print("=== Setting up Knowledge Graph Memory ===")
    print("Source: https://glama.ai/mcp/servers/@joleyline/mcp-memory-libsql")
    
    memory_graph_params = {
        "command": "npx",
        "args": ["-y", "mcp-memory-libsql"],
        "env": {"LIBSQL_URL": "file:./twin/memory/graph.db"}
    }
    
    try:
        async with MCPServerStdio(params=memory_graph_params, client_session_timeout_seconds=30) as memory_graph:
            memory_graph_tools = await memory_graph.session.list_tools()
            print(f"✅ Knowledge Graph tools available: {[tool.name for tool in memory_graph_tools.tools]}")
            return memory_graph_tools.tools
    except Exception as e:
        print(f"❌ Knowledge Graph setup failed: {e}")
        return []

async def setup_memory_rag():
    """Setup Vector Store RAG memory built on Qdrant"""
    print("\n=== Setting up RAG Memory ===")
    print("Source: https://glama.ai/mcp/servers/@qdrant/mcp-server-qdrant")
    
    memory_rag_params = {
        "command": "uvx",
        "args": ["mcp-server-qdrant"],
        "env": {
            "QDRANT_LOCAL_PATH": "./twin/memory/knowledge/",
            "COLLECTION_NAME": "knowledge",
            "EMBEDDING_MODEL": "sentence-transformers/all-MiniLM-L6-v2"
        }
    }
    
    try:
        async with MCPServerStdio(params=memory_rag_params, client_session_timeout_seconds=30) as memory_rag:
            memory_rag_tools = await memory_rag.session.list_tools()
            print(f"✅ RAG Memory tools available: {[tool.name for tool in memory_rag_tools.tools]}")
            return memory_rag_tools.tools
    except Exception as e:
        print(f"❌ RAG Memory setup failed: {e}")
        return []

def setup_questions_db():
    """Setup SQLite database for FAQ functionality"""
    print("\n=== Setting up Questions Database ===")
    
    DB = "./twin/memory/questions.db"
    
    # Create directory if it doesn't exist
    os.makedirs(os.path.dirname(DB), exist_ok=True)
    
    with sqlite3.connect(DB) as conn:
        cursor = conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS questions (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                question TEXT,
                answer TEXT
            )
        ''')
        conn.commit()
    
    print(f"✅ Questions database initialized at: {DB}")
    return DB

def record_question_with_no_answer(question: str, db_path: str = "./twin/memory/questions.db") -> str:
    """Record a question without an answer"""
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO questions (question, answer) VALUES (?, NULL)", (question,))
        conn.commit()
        return "Recorded question with no answer"

def get_questions_with_no_answer(db_path: str = "./twin/memory/questions.db") -> str:
    """Get all questions that don't have answers"""
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT id, question FROM questions WHERE answer IS NULL")
        rows = cursor.fetchall()
        if rows:
            return "\n".join(f"Question id {row[0]}: {row[1]}" for row in rows)
        else:
            return "No questions with no answer found"

def get_questions_with_answer(db_path: str = "./twin/memory/questions.db") -> str:
    """Get all questions that have answers"""
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute("SELECT question, answer FROM questions WHERE answer IS NOT NULL")
        rows = cursor.fetchall()
        return "\n".join(f"Question: {row[0]}\nAnswer: {row[1]}\n" for row in rows)

def record_answer_to_question(id: int, answer: str, db_path: str = "./twin/memory/questions.db") -> str:
    """Record an answer to an existing question"""
    with sqlite3.connect(db_path) as conn:
        cursor = conn.cursor()
        cursor.execute("UPDATE questions SET answer = ? WHERE id = ?", (answer, id))
        conn.commit()
        return "Recorded answer to question"

async def test_memory_systems():
    """Test all memory systems"""
    print("\n=== Testing Memory Systems ===")
    
    # Test knowledge graph
    graph_tools = await setup_memory_graph()
    
    # Test RAG memory
    rag_tools = await setup_memory_rag()
    
    # Test questions database
    db_path = setup_questions_db()
    
    print("\n=== Testing FAQ Database ===")
    
    # Test database functions
    print("Questions with no answer:")
    print(get_questions_with_no_answer(db_path))
    
    print("\nQuestions with answers:")
    print(get_questions_with_answer(db_path))
    
    # Add a test question
    print(f"\nAdding test question...")
    result = record_question_with_no_answer("What is your favorite musical instrument?", db_path)
    print(result)
    
    # Add an answer to question ID 1 (assuming it exists)
    print(f"\nAdding test answer...")
    try:
        result = record_answer_to_question(1, "Guitar - it's versatile and expressive", db_path)
        print(result)
    except Exception as e:
        print(f"Could not add answer: {e}")
    
    print("\nUpdated questions with answers:")
    print(get_questions_with_answer(db_path))
    
    return {
        "graph_tools": graph_tools,
        "rag_tools": rag_tools,
        "db_path": db_path
    }

async def main():
    """Main function to run all memory system tests"""
    print("🧠 LAB 5 - CONTEXT ENGINEERING")
    print("=" * 50)
    
    try:
        results = await test_memory_systems()
        
        print("\n" + "=" * 50)
        print("🎯 MEMORY SYSTEMS SUMMARY")
        print("=" * 50)
        
        print(f"📊 Knowledge Graph Tools: {len(results['graph_tools'])} available")
        print(f"🔍 RAG Memory Tools: {len(results['rag_tools'])} available")
        print(f"❓ FAQ Database: {results['db_path']}")
        
        print("\n✅ Lab 5 completed successfully!")
        
    except Exception as e:
        print(f"❌ Error in main execution: {e}")
        raise

if __name__ == "__main__":
    asyncio.run(main())