from dotenv import load_dotenv
import os
import subprocess
import asyncio
from agents.mcp import MCPServerStdio

load_dotenv(override=True)

async def test_mcp_filesystem():
    """Test MCP filesystem server configuration"""
    print("=== TESTING MCP FILESYSTEM SERVER ===")
    
    current_dir = os.getcwd()
    sandbox_path = os.path.abspath(os.path.join(current_dir, "week4", "sandbox"))
    airline_path = os.path.join(sandbox_path, "airline.py")
    
    print(f"Current dir: {current_dir}")
    print(f"Sandbox path: {sandbox_path}")
    print(f"Airline path: {airline_path}")
    print(f"File exists: {os.path.exists(airline_path)}")
    
    # Test different path configurations
    test_paths = [
        ("Sandbox directory", sandbox_path),
        ("Parent directory", current_dir),
        ("Week4 directory", os.path.join(current_dir, "week4")),
    ]
    
    for name, test_path in test_paths:
        print(f"\n--- Testing {name}: {test_path} ---")
        
        files_params = {
            "command": "npx", 
            "args": ["-y", "@modelcontextprotocol/server-filesystem", test_path]
        }
        
        try:
            async with MCPServerStdio(params=files_params, client_session_timeout_seconds=10) as filesystem:
                tools = await filesystem.session.list_tools()
                print(f"✅ Server started successfully")
                print(f"Available tools: {[tool.name for tool in tools.tools]}")
                
                # Try to list files
                try:
                    result = await filesystem.session.call_tool("list_directory", {"path": "."})
                    print(f"Directory listing: {result}")
                except Exception as e:
                    print(f"❌ Directory listing failed: {e}")
                
                # Try to read airline.py with different paths
                test_files = ["airline.py", "./airline.py", "week4/sandbox/airline.py"]
                for file_path in test_files:
                    try:
                        result = await filesystem.session.call_tool("read_file", {"path": file_path})
                        print(f"✅ Successfully read {file_path}")
                        break
                    except Exception as e:
                        print(f"❌ Failed to read {file_path}: {e}")
                        
        except Exception as e:
            print(f"❌ Server failed to start: {e}")

async def test_semgrep_mcp():
    """Test Semgrep MCP server"""
    print("\n=== TESTING SEMGREP MCP SERVER ===")
    
    semgrep_app_token = os.getenv("SEMGREP_APP_TOKEN")
    print(f"SEMGREP_APP_TOKEN set: {'Yes' if semgrep_app_token else 'No'}")
    
    if not semgrep_app_token:
        print("❌ SEMGREP_APP_TOKEN not set - this is required")
        return
    
    semgrep_params = {
        "command": "uvx",
        "args": ["semgrep-mcp"],
        "env": {
            "SEMGREP_APP_TOKEN": semgrep_app_token
        }
    }
    
    try:
        async with MCPServerStdio(params=semgrep_params, client_session_timeout_seconds=30) as semgrep:
            tools = await semgrep.session.list_tools()
            print(f"✅ Semgrep MCP server started successfully")
            print(f"Available tools: {[tool.name for tool in tools.tools]}")
            
            # Test a simple tool that shouldn't timeout
            try:
                result = await semgrep.session.call_tool("get_supported_languages", {})
                print(f"✅ get_supported_languages works: {len(result)} languages")
            except Exception as e:
                print(f"❌ get_supported_languages failed: {e}")
            
            # Test schema tool
            try:
                result = await semgrep.session.call_tool("semgrep_rule_schema", {})
                print(f"✅ semgrep_rule_schema works: {len(result)} chars")
            except Exception as e:
                print(f"❌ semgrep_rule_schema failed: {e}")
                
    except Exception as e:
        print(f"❌ Semgrep server failed: {e}")

def test_local_semgrep():
    """Test if Semgrep works locally"""
    print("\n=== TESTING LOCAL SEMGREP ===")
    
    airline_path = os.path.join(os.getcwd(), "week4", "sandbox", "airline.py")
    
    if not os.path.exists(airline_path):
        print(f"❌ airline.py not found at {airline_path}")
        return
    
    # Test if semgrep command exists
    try:
        result = subprocess.run(["semgrep", "--version"], capture_output=True, text=True, timeout=10)
        if result.returncode == 0:
            print(f"✅ Semgrep installed: {result.stdout.strip()}")
        else:
            print(f"❌ Semgrep version check failed: {result.stderr}")
            return
    except FileNotFoundError:
        print("❌ Semgrep not installed locally")
        return
    except subprocess.TimeoutExpired:
        print("❌ Semgrep version check timed out")
        return
    
    # Test a quick scan
    try:
        print("Testing quick scan...")
        result = subprocess.run([
            "semgrep", 
            "--config=auto", 
            "--timeout=30",
            "--json",
            airline_path
        ], capture_output=True, text=True, timeout=60)
        
        if result.returncode == 0:
            print(f"✅ Local Semgrep scan successful")
            print(f"Output length: {len(result.stdout)} chars")
        else:
            print(f"❌ Local scan failed: {result.stderr}")
            
    except subprocess.TimeoutExpired:
        print("❌ Local Semgrep scan timed out after 60 seconds")
    except Exception as e:
        print(f"❌ Local scan error: {e}")

async def test_environment_variables():
    """Test environment setup"""
    print("\n=== TESTING ENVIRONMENT ===")
    
    required_vars = ["SEMGREP_APP_TOKEN"]
    optional_vars = ["SEMGREP_URL", "SEMGREP_ALLOW_LOCAL_SCAN"]
    
    for var in required_vars:
        value = os.getenv(var)
        if value:
            print(f"✅ {var}: Set (length: {len(value)})")
        else:
            print(f"❌ {var}: Not set")
    
    for var in optional_vars:
        value = os.getenv(var)
        if value:
            print(f"ℹ️  {var}: {value}")
        else:
            print(f"ℹ️  {var}: Not set (optional)")

async def main():
    print("🔍 MCP AND SEMGREP DIAGNOSTIC")
    print("=" * 50)
    
    await test_environment_variables()
    await test_mcp_filesystem()
    await test_semgrep_mcp()
    test_local_semgrep()
    
    print("\n" + "=" * 50)
    print("🏁 DIAGNOSTIC COMPLETE")
    
    print("\n📋 RECOMMENDED FIXES:")
    print("1. If MCP filesystem fails: Try running from a different directory")
    print("2. If Semgrep MCP times out: Check network connectivity to semgrep.dev")
    print("3. If local Semgrep works: Consider using local scanning instead")
    print("4. Check SEMGREP_APP_TOKEN is valid at https://semgrep.dev/")

if __name__ == "__main__":
    asyncio.run(main())