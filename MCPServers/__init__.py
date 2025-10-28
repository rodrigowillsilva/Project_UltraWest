"""
MCPServers Package

This package provides MCP (Model Context Protocol) server functionality
for accessing GitHub repositories and other resources programmatically.
"""

from .mcpServers import (
    MCPServerManager,
    GitHubMCPServer,
    MCPServerConfig,
    MCPServerType
)

__version__ = "1.0.0"
__all__ = [
    "MCPServerManager",
    "GitHubMCPServer",
    "MCPServerConfig",
    "MCPServerType"
]
