# Lab 3 - Enter the Model Context Protocol!
from dotenv import load_dotenv
from agents import Agent, Runner, trace
from agents.mcp import MCPServerStdio
import os
import asyncio

load_dotenv(override=True)
MODEL_NAME = "gpt-4o-mini"
import sys
print("Platform:", sys.platform)
print("WSL check:", "microsoft" in open("/proc/version").read().lower() if sys.platform == "linux" else "Not Linux")

async def main():
    # Correct Playwright MCP server - note: it's headed by default, no --headless=false needed
    fetch_params = {"command": "npx", "args": ["-y", "@playwright/mcp"]}
    
    try:
        async with MCPServerStdio(params=fetch_params, client_session_timeout_seconds=30) as fetch:
            tools = await fetch.session.list_tools()
        print("Fetch tools:", tools.tools)
    except Exception as e:
        print(f"Error with Playwright server: {e}")
        return

    sandbox_path = os.path.abspath(os.path.join(os.getcwd(), "sandbox"))
    files_params = {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", sandbox_path]}
    async with MCPServerStdio(params=files_params, client_session_timeout_seconds=30) as filesystem:
        file_tools = await filesystem.session.list_tools()
    print("Filesystem tools:", file_tools.tools)

    instructions = """You are a web research assistant with browser and file tools. Follow these rules:
            1. ONLY visit official, well-known websites that typically work reliably
            2. If a site fails to load or has issues, try a different official source
            3. Take screenshots to verify page content before proceeding
            4. Include source URLs in all summaries
            5. Write clear, structured markdown with proper headers"""
    input = (
     "1. Bring up a browser and start with databricks.com/company/newsroom or databricks.com/blog "
     "2. Then visit one of the  major tech news site like techcrunch.com or venturebeat.com"
     "3. Search for Databricks and click on at least 1 story on each site, one at a time"
     "4. Write a summary of the news in markdown to a file databricks.md in the sandbox directory"
     "5. If any site doesn't load properly, skip it"
    )

    with trace("News"):
        async with MCPServerStdio(params=fetch_params, client_session_timeout_seconds=120) as fetch:
            async with MCPServerStdio(params=files_params, client_session_timeout_seconds=30) as filesystem:
                agent = Agent(
                    name="News", instructions=instructions,
                    model=MODEL_NAME, mcp_servers=[fetch, filesystem]
                )
                result = await Runner.run(agent, input, max_turns=20)
                print(result.final_output)

if __name__ == "__main__":
    asyncio.run(main())