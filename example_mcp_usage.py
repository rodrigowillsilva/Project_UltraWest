#!/usr/bin/env python3
"""
Example usage of the GitHub MCP Server

This script demonstrates how to use the MCP server to access
GitHub repositories programmatically for your agent.
"""

import sys
import os

# Add MCPServers to path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'MCPServers'))

from mcpServers import MCPServerManager


def example_basic_usage():
    """Example: Basic server initialization and usage."""
    print("=" * 70)
    print("EXAMPLE 1: Basic Usage")
    print("=" * 70)
    
    # Initialize the MCP Server Manager
    manager = MCPServerManager("MCPServers/mcp_config.json")
    
    # List available servers
    print(f"\nAvailable MCP Servers: {manager.list_servers()}")
    
    # Get the GitHub server
    github = manager.get_server("github_primary")
    
    if github:
        print("✓ GitHub MCP Server successfully initialized!")
    else:
        print("✗ Failed to initialize GitHub MCP Server")


def example_repository_access():
    """Example: Accessing repository contents."""
    print("\n" + "=" * 70)
    print("EXAMPLE 2: Repository Access")
    print("=" * 70)
    
    manager = MCPServerManager("MCPServers/mcp_config.json")
    github = manager.get_server("github_primary")
    
    repo = "rodrigowillsilva/Project_UltraWest"
    
    # Get repository contents
    print(f"\nAccessing repository: {repo}")
    contents = github.get_repository_contents(repo)
    print(f"Endpoint: {contents['endpoint']}")
    print(f"Method: {contents['method']}")
    
    # Get specific file
    print(f"\nAccessing specific file: README.md")
    readme_path = github.get_repository_contents(repo, "README.md")
    print(f"Endpoint: {readme_path['endpoint']}")


def example_documentation_access():
    """Example: Accessing repository documentation."""
    print("\n" + "=" * 70)
    print("EXAMPLE 3: Documentation Access")
    print("=" * 70)
    
    manager = MCPServerManager("MCPServers/mcp_config.json")
    github = manager.get_server("github_primary")
    
    repo = "rodrigowillsilva/Project_UltraWest"
    
    # Get README
    print(f"\nFetching README from: {repo}")
    readme = github.get_repository_readme(repo)
    print(f"Endpoint: {readme['endpoint']}")
    print(f"Description: {readme['description']}")


def example_code_search():
    """Example: Searching code in repositories."""
    print("\n" + "=" * 70)
    print("EXAMPLE 4: Code Search")
    print("=" * 70)
    
    manager = MCPServerManager("MCPServers/mcp_config.json")
    github = manager.get_server("github_primary")
    
    # Search for Godot-related code
    print("\nSearching for 'godot' in Project_UltraWest:")
    search = github.search_code("godot", "rodrigowillsilva/Project_UltraWest")
    print(f"Endpoint: {search['endpoint']}")
    print(f"Query: {search['params']['q']}")
    
    # General search
    print("\nGeneral search for 'config_version':")
    search = github.search_code("config_version")
    print(f"Endpoint: {search['endpoint']}")
    print(f"Query: {search['params']['q']}")


def example_issue_tracking():
    """Example: Accessing repository issues."""
    print("\n" + "=" * 70)
    print("EXAMPLE 5: Issue Tracking")
    print("=" * 70)
    
    manager = MCPServerManager("MCPServers/mcp_config.json")
    github = manager.get_server("github_primary")
    
    repo = "rodrigowillsilva/Project_UltraWest"
    
    # Get open issues
    print(f"\nFetching open issues from: {repo}")
    issues = github.get_repository_issues(repo, state="open")
    print(f"Endpoint: {issues['endpoint']}")
    print(f"State: {issues['params']['state']}")
    
    # Get all issues
    print(f"\nFetching all issues from: {repo}")
    all_issues = github.get_repository_issues(repo, state="all")
    print(f"Endpoint: {all_issues['endpoint']}")
    print(f"State: {all_issues['params']['state']}")


def comparison_table():
    """Display comparison between Copilot and MCP Server."""
    print("\n" + "=" * 70)
    print("COMPARISON: GitHub Copilot vs MCP Server")
    print("=" * 70)
    
    print("""
┌─────────────────────────┬──────────────────┬─────────────────┐
│ Feature                 │ GitHub Copilot   │ MCP Server      │
├─────────────────────────┼──────────────────┼─────────────────┤
│ Code suggestions        │ ✅ Excellent     │ ❌ N/A          │
│ API access              │ ❌ No            │ ✅ Full         │
│ Documentation retrieval │ ⚠️  Limited      │ ✅ Complete     │
│ Issue tracking          │ ❌ No            │ ✅ Yes          │
│ Custom queries          │ ❌ No            │ ✅ Yes          │
│ Caching                 │ ❌ No            │ ✅ Yes          │
│ IDE requirement         │ ✅ Yes           │ ❌ No           │
│ Extensibility           │ ❌ No            │ ✅ Yes          │
│ Programmatic access     │ ❌ No            │ ✅ Yes          │
│ Agent integration       │ ⚠️  Limited      │ ✅ Full         │
└─────────────────────────┴──────────────────┴─────────────────┘

RECOMMENDATION: Use BOTH for optimal results!
  • GitHub Copilot: For code suggestions while coding
  • MCP Server: For programmatic GitHub access in your agent
    """)


def main():
    """Run all examples."""
    print("\n" + "🚀" * 35)
    print("GitHub MCP Server - Usage Examples")
    print("🚀" * 35 + "\n")
    
    # Run examples
    example_basic_usage()
    example_repository_access()
    example_documentation_access()
    example_code_search()
    example_issue_tracking()
    comparison_table()
    
    print("\n" + "=" * 70)
    print("CONCLUSION")
    print("=" * 70)
    print("""
To answer the question: "Are github repos accessible more easily by 
github copilot or do I need to use mcp server?"

ANSWER: You need an MCP server for programmatic access!

GitHub Copilot is excellent for code suggestions but doesn't provide
the API access your agent needs to programmatically interact with
GitHub repositories.

The MCP server gives your agent:
  ✓ Direct repository access
  ✓ Documentation retrieval
  ✓ Code search capabilities
  ✓ Issue and PR tracking
  ✓ Full GitHub API integration

For the best experience, use BOTH:
  • Copilot for coding assistance
  • MCP Server for agent automation
    """)
    print("=" * 70 + "\n")


if __name__ == "__main__":
    main()
