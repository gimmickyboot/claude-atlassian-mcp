#!/bin/sh

# Retrieve the pre-encoded Basic Auth token from macOS Keychain
# Keychain entry "confluence_token" stores: base64(email:api_token)
JIRA_B64="$(/usr/bin/security find-generic-password -a "$USER" -s "confluence_token" -w)"

if [ -z "${JIRA_B64}" ]; then
  echo "ERROR: Could not retrieve confluence_token from Keychain" >&2
  echo "Run the Claude Desktop setup script again to configure." >&2
  exit 1
fi

# Use modern Node.js from Homebrew (not old nvm versions)
export PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"


# Run the MCP server
exec npx '-y' 'mcp-remote@latest' 'https://mcp.atlassian.com/v1/mcp' '--header' "Authorization: Basic ${JIRA_B64}"
