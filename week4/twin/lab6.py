#!/usr/bin/env python3
"""
Lab 6 - The Admin Agent (WSL Optimized)

This is the first of our Agents, and it's responsible for talking to us and administering its memory.
Optimized to run on Windows Subsystem for Linux (WSL).
"""

from agents import Agent, Runner, trace
from openai.types.responses import ResponseTextDeltaEvent
from dotenv import load_dotenv
import json
import os
import asyncio
import gradio as gr
from pypdf import PdfReader

# Import custom modules with error handling
try:
    from questions import get_questions_with_no_answer, get_questions_tools
    from contacts import get_people_who_want_to_get_in_touch
    from mcp_servers import memory_graph_server, memory_rag_server
    MODULES_AVAILABLE = True
    print("✅ All custom modules loaded successfully")
except ImportError as e:
    print(f"⚠️  Warning: Could not import some custom modules: {e}")
    print("   The application will run with limited functionality")
    MODULES_AVAILABLE = False

load_dotenv(override=True)

def load_personal_data():
    """Load personal data from files with better error handling"""
    data = {}
    
    # Load LinkedIn PDF
    linkedin_path = "./me/linkedin.pdf"
    if os.path.exists(linkedin_path):
        try:
            reader = PdfReader(linkedin_path)
            linkedin = ""
            for page in reader.pages:
                text = page.extract_text()
                if text:
                    linkedin += text
            data['linkedin'] = linkedin
            print(f"✅ Loaded LinkedIn profile ({len(linkedin)} characters)")
        except Exception as e:
            print(f"❌ Could not load LinkedIn PDF: {e}")
            data['linkedin'] = "LinkedIn profile not available"
    else:
        print(f"ℹ️  LinkedIn PDF not found at {linkedin_path}")
        data['linkedin'] = "LinkedIn profile not available"
    
    # Load summary
    summary_path = "./me/summary.txt"
    if os.path.exists(summary_path):
        try:
            with open(summary_path, "r", encoding="utf-8") as f:
                data['summary'] = f.read()
            print(f"✅ Loaded summary ({len(data['summary'])} characters)")
        except Exception as e:
            print(f"❌ Could not load summary: {e}")
            data['summary'] = "Summary not available"
    else:
        print(f"ℹ️  Summary file not found at {summary_path}")
        data['summary'] = "Summary not available"
    
    # Load facts
    facts_path = "./me/facts.json"
    if os.path.exists(facts_path):
        try:
            with open(facts_path, "r", encoding="utf-8") as f:
                data['facts'] = json.load(f)
            print(f"✅ Loaded facts: {data['facts']}")
        except Exception as e:
            print(f"❌ Could not load facts: {e}")
            data['facts'] = {"full_name": "User", "name": "User"}
    else:
        print(f"ℹ️  Facts file not found at {facts_path}")
        data['facts'] = {"full_name": "User", "name": "User"}
    
    return data

def create_instructions(personal_data):
    """Create instructions for the Admin agent"""
    facts = personal_data['facts']
    summary = personal_data['summary']
    linkedin = personal_data['linkedin']
    
    full_name = facts.get("full_name", "User")
    name = facts.get("name", "User")
    
    # Try to get unanswered questions
    if MODULES_AVAILABLE:
        try:
            unanswered_questions = get_questions_with_no_answer()
        except Exception as e:
            print(f"⚠️  Could not get unanswered questions: {e}")
            unanswered_questions = "No unanswered questions available"
    else:
        unanswered_questions = "Questions module not available"
    
    instructions = f"""
# Your Role

You are an Administrator Agent.
You are part of an Agent Team that is responsible for answering questions about {full_name}, who goes by {name}.

## Important Context

Here is some basic information about {name}:
{facts}

Here is a summary of {name}:
{summary}

Here is the LinkedIn profile of {name}:
{linkedin}

## Your task

As Admin Agent, you are chatting directly with {full_name} who you should address as {name}. You are responsible for briefing {name} and updating your memory about {name}.

Here is a list of questions from users for {name} that have not been answered with their question id:

{unanswered_questions}

## Your tools

You have access to the following memory related tools:
- Tools to manage the long term memory in a Graph database with entities and relationships. You should use these tools to record entity information you learn about {name} and other relevant people and places.
- Tools to manage memory using a Qdrant vector database. These tools let you look up and keep memories.

You should use both these tools together to record new information you learn; it's good to record information in both places.

If {name} offers to answer questions that have not been answered, you can mention those on your list.
Then if {name} is able to provide an answer, you should use your tool to record the answer to the question, and also update your graph memory and your Qdrant memory to reflect your new knowledge.

To be clear: every time {name} answers one of these questions, you should record the answer to the question being careful to specify the right question id,
and also update your graph memory and your Qdrant memory to reflect your new knowledge.

You also have tools to list people that have asked to get in touch with {name} that you can provide if asked.

## Instructions

Now with this context, proceed with your conversation with {name}.
"""
    return instructions

async def chat(message, history):
    """Chat function for Gradio interface with improved error handling"""
    try:
        # Convert Gradio history format to messages
        messages = []
        for h in history:
            if isinstance(h, dict) and "role" in h and "content" in h:
                messages.append({"role": h["role"], "content": h["content"]})
            elif isinstance(h, (list, tuple)) and len(h) >= 2:
                # Handle Gradio's tuple format (user_message, bot_message)
                if h[0]:  # user message
                    messages.append({"role": "user", "content": h[0]})
                if h[1]:  # bot message
                    messages.append({"role": "assistant", "content": h[1]})
        
        # Add current message
        messages.append({"role": "user", "content": message})
        
        # Load personal data and create instructions
        personal_data = load_personal_data()
        instructions = create_instructions(personal_data)
        
        # Get tools (with fallback if modules not available)
        tools = []
        if MODULES_AVAILABLE:
            try:
                tools = get_questions_tools() + [get_people_who_want_to_get_in_touch]
                print(f"✅ Loaded {len(tools)} tools")
            except Exception as e:
                print(f"⚠️  Could not load tools: {e}")
                tools = []
        
        with trace("Admin"):
            try:
                # Try to use MCP servers if available
                if MODULES_AVAILABLE:
                    async with memory_rag_server() as rag_server:
                        async with memory_graph_server() as graph_server:
                            agent = Agent(
                                "Admin", 
                                instructions=instructions, 
                                model="gpt-4.1", 
                                tools=tools, 
                                mcp_servers=[rag_server, graph_server]
                            )
                            result = Runner.run_streamed(agent, messages)
                            reply = ""
                            async for event in result.stream_events():
                                if event.type == "raw_response_event" and isinstance(event.data, ResponseTextDeltaEvent):
                                    reply += event.data.delta
                                    yield reply
                else:
                    # Fallback without MCP servers
                    agent = Agent(
                        "Admin", 
                        instructions=instructions, 
                        model="gpt-4.1", 
                        tools=tools
                    )
                    result = Runner.run_streamed(agent, messages)
                    reply = ""
                    async for event in result.stream_events():
                        if event.type == "raw_response_event" and isinstance(event.data, ResponseTextDeltaEvent):
                            reply += event.data.delta
                            yield reply
                            
            except Exception as e:
                print(f"⚠️  MCP servers not available, running in basic mode: {e}")
                # Final fallback - basic agent without memory
                agent = Agent(
                    "Admin", 
                    instructions=instructions, 
                    model="gpt-4.1", 
                    tools=[]
                )
                result = Runner.run_streamed(agent, messages)
                reply = ""
                async for event in result.stream_events():
                    if event.type == "raw_response_event" and isinstance(event.data, ResponseTextDeltaEvent):
                        reply += event.data.delta
                        yield reply
                        
    except Exception as e:
        error_msg = f"Error in chat: {str(e)}"
        print(f"❌ {error_msg}")
        yield error_msg

def create_sample_files():
    """Create sample files if they don't exist"""
    print("📁 Checking for required files...")
    
    # Create me directory
    os.makedirs("./me", exist_ok=True)
    
    # Create sample facts.json
    facts_path = "./me/facts.json"
    if not os.path.exists(facts_path):
        sample_facts = {
            "full_name": "John Doe",
            "name": "John",
            "occupation": "Software Engineer",
            "location": "San Francisco, CA",
            "skills": ["Python", "JavaScript", "AI/ML"],
            "experience_years": 5
        }
        with open(facts_path, "w", encoding="utf-8") as f:
            json.dump(sample_facts, f, indent=2)
        print(f"✅ Created sample facts.json at {facts_path}")
    else:
        print(f"✅ Found existing facts.json")
    
    # Create sample summary.txt
    summary_path = "./me/summary.txt"
    if not os.path.exists(summary_path):
        sample_summary = """John is a passionate software engineer with 5+ years of experience in building scalable web applications. 
He specializes in Python and JavaScript, with recent focus on AI/ML applications and digital twin technologies.
John is known for his collaborative approach and mentoring junior developers. He enjoys working on challenging 
technical problems and has experience with both backend systems and modern frontend frameworks.

Key achievements:
- Led development of several high-traffic web applications
- Implemented AI-powered features for enterprise clients
- Mentored 10+ junior developers
- Contributed to open-source projects with 1000+ stars"""
        with open(summary_path, "w", encoding="utf-8") as f:
            f.write(sample_summary)
        print(f"✅ Created sample summary.txt at {summary_path}")
    else:
        print(f"✅ Found existing summary.txt")
    
    # Check for LinkedIn PDF
    linkedin_path = "./me/linkedin.pdf"
    if not os.path.exists(linkedin_path):
        print(f"ℹ️  LinkedIn PDF not found at {linkedin_path}")
        print("   You can export your LinkedIn profile as PDF and place it there")
        print("   The application will work without it, using fallback data")
    else:
        print(f"✅ Found LinkedIn PDF")

def create_memory_directories():
    """Create memory directories for databases"""
    print("📊 Setting up memory storage...")
    
    # Create memory directory structure
    os.makedirs("./memory", exist_ok=True)
    os.makedirs("./memory/knowledge", exist_ok=True)
    
    print("✅ Memory directories created")

def main():
    """Main function to run the Admin Agent interface"""
    print("🤖 LAB 6 - THE ADMIN AGENT (WSL OPTIMIZED)")
    print("=" * 50)
    
    # Create required directories and files
    create_sample_files()
    create_memory_directories()
    
    # Load and display personal data
    print("\n📋 Loading personal data...")
    personal_data = load_personal_data()
    
    # Display configuration summary
    print(f"\n👤 Configuration Summary:")
    print(f"   Name: {personal_data['facts'].get('name', 'Unknown')}")
    print(f"   Full Name: {personal_data['facts'].get('full_name', 'Unknown')}")
    print(f"   LinkedIn: {'Available' if len(personal_data['linkedin']) > 50 else 'Not available'}")
    print(f"   Summary: {'Available' if len(personal_data['summary']) > 50 else 'Not available'}")
    print(f"   Custom Modules: {'Available' if MODULES_AVAILABLE else 'Limited'}")
    
    # Example questions
    examples = [
        "Are there any questions that are not answered yet?",
        "Has anyone asked to get in touch with me?",
        "Please summarize your memory of me",
        "What do you know about my background?",
        "Help me update my information",
        "What tools do you have available?",
        "Show me my current status"
    ]
    
    # Set up authentication
    admin_password = os.getenv("ADMIN_PASSWORD", "admin")
    auth = [("admin", admin_password)]
    
    print(f"\n🚀 Starting Gradio interface...")
    print(f"🔐 Login: admin / {admin_password}")
    print(f"🌐 The interface will be available at:")
    print(f"   - Local: http://localhost:7860")
    print(f"   - WSL: http://<your-wsl-ip>:7860")
    
    # Create Gradio interface with WSL-optimized settings
    try:
        theme = gr.themes.Default(primary_hue="sky")
        
        interface = gr.ChatInterface(
            chat, 
            type="messages", 
            examples=examples,
            title="🤖 Admin Agent - Personal Assistant",
            description="Chat with your personal Admin Agent to manage your information and answer questions.",
            theme=theme
        )
        
        # Launch with WSL-friendly settings
        interface.launch(
            auth=auth,
            server_name="0.0.0.0",  # Allow external access for WSL
            server_port=7860,
            share=False,
            debug=False,
            show_error=True,
            inbrowser=True  # Try to open browser (works if X11 forwarding is enabled)
        )
        
    except Exception as e:
        print(f"❌ Error launching Gradio interface: {e}")
        print("\n🔧 Troubleshooting tips:")
        print("   1. Make sure you have Gradio installed: pip install gradio")
        print("   2. Check if port 7860 is available")
        print("   3. For WSL, ensure you can access localhost:7860 from Windows")
        print("   4. Try running with: python lab6_wsl.py")
        
        # Fallback: simple command-line interface
        print("\n🔄 Attempting simple command-line fallback...")
        try:
            personal_data = load_personal_data()
            instructions = create_instructions(personal_data)
            print("\n" + "="*50)
            print("ADMIN AGENT - COMMAND LINE MODE")
            print("="*50)
            print("Instructions preview:")
            print(instructions[:500] + "..." if len(instructions) > 500 else instructions)
            print("\nGradio interface failed, but the agent code is working!")
            print("Check the error above and ensure all dependencies are installed.")
        except Exception as fallback_error:
            print(f"❌ Fallback also failed: {fallback_error}")

if __name__ == "__main__":
    # Ensure we're using the right event loop policy for asyncio
    if os.name == 'nt':  # Windows
        asyncio.set_event_loop_policy(asyncio.WindowsProactorEventLoopPolicy())
    
    try:
        main()
    except KeyboardInterrupt:
        print("\n👋 Goodbye!")
    except Exception as e:
        print(f"❌ Fatal error: {e}")
        print("Please check the error and try again.")