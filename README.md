# Preview FusionAuth API MCP Server (fusionauth-mcp-api)

[![npm version](https://img.shields.io/npm/v/fusionauth-mcp-api.svg)](https://www.npmjs.com/package/@fusionauth/mcp-api)
[![License: Apache](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/license/apache-2-0)
[![GitHub repository](https://img.shields.io/badge/GitHub-FusionAuth/fusionauth--mcp--api-blue.svg)](https://github.com/FusionAuth/fusionauth-mcp-api)

Preview MCP server for the FusionAuth API.
Built with the excellent [github.com/harsha-iiiv/openapi-mcp-generator](https://github.com/harsha-iiiv/openapi-mcp-generator)

## ⚠️  Not for Production Use!

Using this MCP server requires providing the MCP client with a FusionAuth API key. Only use this for dev and test instances. FusionAuth is not responsible for potentially leaking sensitive information.

--

## Simple configuration

Coming soon after publishing to npmjs

## Building locally

```bash
git clone https://github.com/FusionAuth/fusionauth-mcp-api.git
cd fusionauth-mcp-api
cd packages/mcp-api
npm install
npm run build

# optional step to store config information in .env file
cp .env.example .env
# optionally edit .env to set API_BASE_URL and API_KEY_APIKEYAUTH
```

Configure your MCP client to use the FusionAuth API MCP server.

For example, edit `~/Library/Application Support/Claude/claude_desktop_config.json` to include

```json
{
  "mcpServers": {
    "fusionauth-api-server": {
      "command": "npm",
      "args": [
        "run",
        "--silent",
        "--prefix",
        "<path to local git repo>/fusionauth-mcp-api/packages/mcp-api",
        "start"
      ],
      "env": {
        "API_KEY_APIKEYAUTH": "<your fusionauth api key>",
        "API_BASE_URL": "http://localhost:9011"
      }
    }
  }
}

## Example Prompts

"how many fusionauth applications do I have?"

## Troubleshooting

Check your MCP client logs. For example, `$HOME/Library/Logs/Claude/mcp-server-fusionauth-api-server.log`

Try the modelcontextprotocol inspector `npx @modelcontextprotocol/inspector`
