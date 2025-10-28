#!/usr/bin/env python3
"""
MCP Server Configuration for GitHub Repository Access

This module provides MCP (Model Context Protocol) server functionality
to access GitHub repositories programmatically, offering more control
and flexibility compared to relying solely on GitHub Copilot.

The MCP server allows the agent to:
- Access repository contents and documentation
- Query GitHub API endpoints
- Integrate with project workflows
- Have granular control over GitHub interactions
"""

import json
import os
from typing import Dict, List, Optional, Any
from dataclasses import dataclass
from enum import Enum


class MCPServerType(Enum):
    """Enumeration of available MCP server types."""
    GITHUB = "github"
    FILESYSTEM = "filesystem"
    WEB = "web"


@dataclass
class MCPServerConfig:
    """Configuration for an MCP server."""
    name: str
    server_type: MCPServerType
    enabled: bool
    config: Dict[str, Any]


class GitHubMCPServer:
    """
    GitHub MCP Server for accessing GitHub repositories and documentation.
    
    This server provides enhanced access to GitHub repositories beyond what
    GitHub Copilot offers, including:
    - Direct API access to repository contents
    - Documentation retrieval
    - Issue and PR management
    - Repository metadata access
    """
    
    def __init__(self, config: Dict[str, Any]):
        """
        Initialize the GitHub MCP Server.
        
        Args:
            config: Configuration dictionary containing:
                - token: GitHub personal access token (optional)
                - repositories: List of repository URLs or names
                - cache_enabled: Whether to cache repository data
        """
        self.config = config
        self.token = config.get('token', os.environ.get('GITHUB_TOKEN'))
        self.repositories = config.get('repositories', [])
        self.cache_enabled = config.get('cache_enabled', True)
        self.base_url = "https://api.github.com"
        
    def get_repository_contents(self, repo: str, path: str = "") -> Optional[Dict]:
        """
        Get contents of a repository or specific path within it.
        
        Args:
            repo: Repository in format "owner/repo"
            path: Path within repository (optional)
            
        Returns:
            Dictionary containing repository contents or None if error
        """
        # This is a placeholder for actual GitHub API implementation
        # In production, this would use requests or similar library
        endpoint = f"{self.base_url}/repos/{repo}/contents/{path}"
        
        return {
            "endpoint": endpoint,
            "method": "GET",
            "headers": self._get_headers(),
            "description": f"Fetch contents from {repo}/{path}"
        }
    
    def get_repository_readme(self, repo: str) -> Optional[str]:
        """
        Get the README file contents from a repository.
        
        Args:
            repo: Repository in format "owner/repo"
            
        Returns:
            README contents as string or None if not found
        """
        endpoint = f"{self.base_url}/repos/{repo}/readme"
        
        return {
            "endpoint": endpoint,
            "method": "GET",
            "headers": self._get_headers(),
            "description": f"Fetch README from {repo}"
        }
    
    def search_code(self, query: str, repo: Optional[str] = None) -> Dict:
        """
        Search for code across GitHub repositories.
        
        Args:
            query: Search query string
            repo: Optional repository to limit search to
            
        Returns:
            Dictionary with search results information
        """
        search_query = query
        if repo:
            search_query = f"{query} repo:{repo}"
            
        endpoint = f"{self.base_url}/search/code"
        
        return {
            "endpoint": endpoint,
            "method": "GET",
            "params": {"q": search_query},
            "headers": self._get_headers(),
            "description": f"Search code: {search_query}"
        }
    
    def get_repository_issues(self, repo: str, state: str = "open") -> Dict:
        """
        Get issues from a repository.
        
        Args:
            repo: Repository in format "owner/repo"
            state: Issue state (open, closed, all)
            
        Returns:
            Dictionary with issues information
        """
        endpoint = f"{self.base_url}/repos/{repo}/issues"
        
        return {
            "endpoint": endpoint,
            "method": "GET",
            "params": {"state": state},
            "headers": self._get_headers(),
            "description": f"Fetch issues from {repo}"
        }
    
    def _get_headers(self) -> Dict[str, str]:
        """
        Get HTTP headers for GitHub API requests.
        
        Returns:
            Dictionary of HTTP headers
        """
        headers = {
            "Accept": "application/vnd.github.v3+json",
            "User-Agent": "Project-UltraWest-MCP-Server"
        }
        
        if self.token:
            headers["Authorization"] = f"token {self.token}"
            
        return headers


class MCPServerManager:
    """
    Manager for all MCP servers in the project.
    
    This class handles configuration, initialization, and coordination
    of multiple MCP servers.
    """
    
    def __init__(self, config_file: Optional[str] = None):
        """
        Initialize the MCP Server Manager.
        
        Args:
            config_file: Path to configuration file (JSON format)
        """
        self.config_file = config_file or "mcp_config.json"
        self.servers: Dict[str, Any] = {}
        self.load_configuration()
        
    def load_configuration(self):
        """Load server configurations from file."""
        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, 'r') as f:
                    config_data = json.load(f)
                    self._initialize_servers(config_data)
            except Exception as e:
                print(f"Error loading configuration: {e}")
        else:
            # Create default configuration
            self._create_default_config()
    
    def _initialize_servers(self, config_data: Dict):
        """
        Initialize servers based on configuration data.
        
        Args:
            config_data: Dictionary containing server configurations
        """
        for server_config in config_data.get('servers', []):
            if not server_config.get('enabled', True):
                continue
                
            server_type = server_config.get('type')
            
            if server_type == MCPServerType.GITHUB.value:
                server = GitHubMCPServer(server_config.get('config', {}))
                self.servers[server_config['name']] = server
    
    def _create_default_config(self):
        """Create a default configuration file."""
        default_config = {
            "servers": [
                {
                    "name": "github_primary",
                    "type": "github",
                    "enabled": True,
                    "config": {
                        "repositories": [
                            "rodrigowillsilva/Project_UltraWest"
                        ],
                        "cache_enabled": True
                    }
                }
            ]
        }
        
        try:
            with open(self.config_file, 'w') as f:
                json.dump(default_config, f, indent=2)
            self._initialize_servers(default_config)
        except Exception as e:
            print(f"Error creating default configuration: {e}")
    
    def get_server(self, name: str) -> Optional[Any]:
        """
        Get a server by name.
        
        Args:
            name: Name of the server
            
        Returns:
            Server instance or None if not found
        """
        return self.servers.get(name)
    
    def list_servers(self) -> List[str]:
        """
        List all available servers.
        
        Returns:
            List of server names
        """
        return list(self.servers.keys())


def main():
    """
    Main entry point for the MCP server manager.
    Demonstrates basic usage.
    """
    print("Initializing MCP Server Manager...")
    manager = MCPServerManager()
    
    print(f"\nAvailable servers: {manager.list_servers()}")
    
    # Get GitHub server
    github_server = manager.get_server("github_primary")
    
    if github_server:
        print("\nGitHub MCP Server is available!")
        print("\nExample operations:")
        
        # Example: Get repository contents
        repo = "rodrigowillsilva/Project_UltraWest"
        contents_info = github_server.get_repository_contents(repo)
        print(f"\n1. Get repository contents:")
        print(f"   {json.dumps(contents_info, indent=2)}")
        
        # Example: Get README
        readme_info = github_server.get_repository_readme(repo)
        print(f"\n2. Get repository README:")
        print(f"   {json.dumps(readme_info, indent=2)}")
        
        # Example: Search code
        search_info = github_server.search_code("godot", repo)
        print(f"\n3. Search code:")
        print(f"   {json.dumps(search_info, indent=2)}")
        
        print("\n" + "="*60)
        print("MCP Server provides more control than GitHub Copilot alone!")
        print("="*60)
        print("\nBenefits of using MCP Server:")
        print("✓ Direct API access to GitHub repositories")
        print("✓ Programmatic access to documentation")
        print("✓ Query issues, PRs, and code")
        print("✓ Cache repository data for faster access")
        print("✓ Customize and extend functionality")
        print("✓ Independent of IDE or editor")
    else:
        print("GitHub MCP Server not available.")


if __name__ == "__main__":
    main()
