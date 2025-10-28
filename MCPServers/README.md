# MCP Server for GitHub Repository Access

## Overview

This directory contains the MCP (Model Context Protocol) server implementation for accessing GitHub repositories. The MCP server provides programmatic access to GitHub, offering more control and flexibility compared to relying solely on GitHub Copilot.

## Why Use MCP Server Instead of Just GitHub Copilot?

### GitHub Copilot Limitations
- **Read-only suggestions**: Copilot provides code suggestions based on context but doesn't offer direct API access
- **IDE-dependent**: Requires specific IDE integration
- **Limited control**: Cannot programmatically query repositories or documentation
- **No customization**: Fixed functionality without extension capabilities

### MCP Server Benefits
✅ **Direct API Access**: Programmatically access any GitHub repository  
✅ **Full Control**: Query issues, PRs, code, and documentation on demand  
✅ **Caching**: Store repository data locally for faster access  
✅ **Extensible**: Add custom functionality and integrate with workflows  
✅ **IDE-Independent**: Works with any agent or automation system  
✅ **Flexible Authentication**: Use personal access tokens for private repos  

## File Structure

```
MCPServers/
├── mcpServers.py         # Main MCP server implementation
├── mcp_config.json       # Server configuration file
└── README.md            # This documentation file
```

## Installation

### Prerequisites

```bash
# Python 3.7 or higher
python --version

# Optional: Install requests library for HTTP operations
pip install requests
```

### Setup

1. **Configure GitHub Token (Optional)**
   
   For private repositories or higher rate limits, set up a GitHub personal access token:
   
   ```bash
   export GITHUB_TOKEN="your_github_token_here"
   ```

2. **Configure Repositories**
   
   Edit `mcp_config.json` to add repositories you want to access:
   
   ```json
   {
     "repositories": [
       "rodrigowillsilva/Project_UltraWest",
       "owner/another-repo"
     ]
   }
   ```

## Usage

### Basic Usage

Run the MCP server manager:

```bash
cd MCPServers
python mcpServers.py
```

This will:
- Initialize the MCP server manager
- Load configuration from `mcp_config.json`
- Display available servers
- Show example operations

### Programmatic Usage

```python
from mcpServers import MCPServerManager

# Initialize the manager
manager = MCPServerManager()

# Get GitHub server
github_server = manager.get_server("github_primary")

# Access repository contents
repo = "rodrigowillsilva/Project_UltraWest"
contents = github_server.get_repository_contents(repo)

# Get README
readme = github_server.get_repository_readme(repo)

# Search code
results = github_server.search_code("godot", repo)

# Get issues
issues = github_server.get_repository_issues(repo, state="open")
```

## Configuration

### Server Configuration (`mcp_config.json`)

```json
{
  "servers": [
    {
      "name": "github_primary",
      "type": "github",
      "enabled": true,
      "config": {
        "repositories": ["owner/repo"],
        "cache_enabled": true,
        "token": "${GITHUB_TOKEN}"
      }
    }
  ],
  "global_settings": {
    "log_level": "info",
    "cache_directory": ".mcp_cache",
    "request_timeout": 30
  }
}
```

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `name` | Unique server identifier | Required |
| `type` | Server type (github, filesystem, web) | Required |
| `enabled` | Whether server is active | true |
| `repositories` | List of repositories to access | [] |
| `cache_enabled` | Enable local caching | true |
| `token` | GitHub personal access token | None |

## API Reference

### GitHubMCPServer

#### `get_repository_contents(repo, path="")`
Get contents of a repository or specific path.

**Parameters:**
- `repo` (str): Repository in format "owner/repo"
- `path` (str): Optional path within repository

**Returns:** Dictionary with endpoint information

#### `get_repository_readme(repo)`
Get the README file from a repository.

**Parameters:**
- `repo` (str): Repository in format "owner/repo"

**Returns:** Dictionary with endpoint information

#### `search_code(query, repo=None)`
Search for code across GitHub repositories.

**Parameters:**
- `query` (str): Search query string
- `repo` (str): Optional repository to limit search

**Returns:** Dictionary with search information

#### `get_repository_issues(repo, state="open")`
Get issues from a repository.

**Parameters:**
- `repo` (str): Repository in format "owner/repo"
- `state` (str): Issue state (open, closed, all)

**Returns:** Dictionary with issues information

## Integration with Your Agent

To integrate this MCP server with your agent:

1. **Import the module** in your agent code:
   ```python
   from MCPServers.mcpServers import MCPServerManager
   ```

2. **Initialize during agent startup**:
   ```python
   self.mcp_manager = MCPServerManager("MCPServers/mcp_config.json")
   self.github = self.mcp_manager.get_server("github_primary")
   ```

3. **Use in your agent's logic**:
   ```python
   # When agent needs documentation
   readme = self.github.get_repository_readme("rodrigowillsilva/Project_UltraWest")
   
   # When agent needs to search code
   results = self.github.search_code("function name")
   ```

## Comparison: Copilot vs MCP Server

| Feature | GitHub Copilot | MCP Server |
|---------|---------------|------------|
| Code suggestions | ✅ Excellent | ❌ Not applicable |
| API access | ❌ No | ✅ Full access |
| Documentation retrieval | ⚠️ Limited | ✅ Complete |
| Issue tracking | ❌ No | ✅ Yes |
| Custom queries | ❌ No | ✅ Yes |
| Caching | ❌ No | ✅ Yes |
| IDE requirement | ✅ Yes | ❌ No |
| Extensibility | ❌ No | ✅ Yes |

## Best Practice: Use Both!

The optimal approach is to use **both** GitHub Copilot and MCP Server:

- **GitHub Copilot**: For code suggestions and completions while coding
- **MCP Server**: For programmatic access to repositories, documentation, and GitHub data

This combination provides:
- 🎯 Smart code suggestions (Copilot)
- 🔌 Programmatic GitHub access (MCP Server)
- 📚 On-demand documentation retrieval (MCP Server)
- 🤖 Agent automation capabilities (MCP Server)

## Troubleshooting

### Rate Limiting
If you encounter rate limiting errors, add a GitHub personal access token:
```bash
export GITHUB_TOKEN="your_token_here"
```

### Authentication Issues
Verify your token has the correct permissions:
- `repo`: For private repositories
- `public_repo`: For public repositories only

### Configuration Not Loading
Ensure `mcp_config.json` is valid JSON:
```bash
python -m json.tool mcp_config.json
```

## License

This MCP server implementation is part of the Project_UltraWest repository.

## Support

For issues or questions:
1. Check the documentation above
2. Review example usage in `mcpServers.py`
3. Open an issue in the repository

---

**Answer to the Original Question:**

*"Are github repos accessible more easily by github copilot or do I need to use mcp server like any other website I want my agent to use?"*

**Answer:** You need to use an MCP server (like the one implemented here) for programmatic access to GitHub repositories. GitHub Copilot is designed for code suggestions within an IDE, not for giving your agent direct access to repository contents, documentation, or GitHub API features. The MCP server provides the control and flexibility needed for an agent to interact with GitHub programmatically.
