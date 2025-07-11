
#!/usr/bin/env python3
from dotenv import load_dotenv
import os
from agents import Agent, Runner, trace
from agents.mcp import MCPServerStdio
import asyncio

load_dotenv(override=True)

semgrep_app_token = os.getenv("SEMGREP_APP_TOKEN")

import sys
print("Platform:", sys.platform)
print("WSL check:", "microsoft" in open("/proc/version").read().lower() if sys.platform == "linux" else "Not Linux")

async def main():
    semgrep_params = {
        "command": "uvx",
        "args": ["semgrep-mcp"],
        "env": {
            "SEMGREP_APP_TOKEN": semgrep_app_token
        }
    }

    try:
        async with MCPServerStdio(params=semgrep_params, client_session_timeout_seconds=30) as semgrep:
            semgrep_tools = await semgrep.session.list_tools()
        print("Fetch tools:", semgrep_tools.tools)
    except Exception as e:
        print(f"Error with semgrep server: {e}")
        return

    # Use current directory for filesystem server
    current_dir = os.getcwd()
    print(f"Current directory: {current_dir}")
    
    files_params = {"command": "npx", "args": ["-y", "@modelcontextprotocol/server-filesystem", current_dir]}

    # Test filesystem connection first
    try:
        async with MCPServerStdio(params=files_params, client_session_timeout_seconds=30) as filesystem:
            file_tools = await filesystem.session.list_tools()
            print("Filesystem tools available:", [tool.name for tool in file_tools.tools])
    except Exception as e:
        print(f"Filesystem server failed: {e}")
        return

    instructions = """
    You are a cybersecurity researcher. You have access to Semgrep tools and file system tools.
    
    Your task:
    1. Read the file "week4/sandbox/airline.py" using the read_file tool
    2. Use the security_check tool to scan the code content for security vulnerabilities
    3. Provide a concise security analysis
    
    Note: The security_check tool expects code content in the format [{"filename": "airline.py", "content": "file_content_here"}]
    
    Be patient - Semgrep tools may take several minutes to complete due to network connectivity.
    """

    with trace("Security Researcher"):
        # Use extended timeouts for Semgrep
        async with MCPServerStdio(params=semgrep_params, client_session_timeout_seconds=600) as semgrep:
            async with MCPServerStdio(params=files_params, client_session_timeout_seconds=30) as filesystem:
                
                agent = Agent(
                    name="Security Researcher", 
                    instructions=instructions, 
                    model="gpt-4.1", 
                    mcp_servers=[semgrep, filesystem], 
                    mcp_config={"allowed_tools": ["semgrep_scan","security_check", "read_file"]}
                )
                
                try:
                    result = await asyncio.wait_for(
                        Runner.run(agent, input='Read the file "week4/sandbox/airline.py" and then run a security check on it using the security_check tool. Be patient as Semgrep may take several minutes.'),
                        timeout=480  # 8 minutes
                    )
                    report = result.final_output
                except asyncio.TimeoutError:
                    report = "Security check timed out after 8 minutes."

    print("\n" + "="*60)
    print("SECURITY ANALYSIS REPORT")
    print("="*60)
    print(report)

if __name__ == "__main__":
    asyncio.run(main())