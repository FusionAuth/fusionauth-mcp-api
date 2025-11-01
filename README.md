# Preview FusionAuth API MCP Server (fusionauth-mcp-api)

[![npm version](https://img.shields.io/npm/v/fusionauth-mcp-api.svg)](https://www.npmjs.com/package/@fusionauth/mcp-api)
[![License: Apache](https://img.shields.io/badge/License-Apache-yellow.svg)](https://opensource.org/license/apache-2-0)
[![GitHub repository](https://img.shields.io/badge/GitHub-FusionAuth/fusionauth--mcp--api-blue.svg)](https://github.com/FusionAuth/fusionauth-mcp-api)

Preview MCP server for the FusionAuth API.
Built with the excellent [github.com/harsha-iiiv/openapi-mcp-generator](https://github.com/harsha-iiiv/openapi-mcp-generator)

## ⚠️  Not for Production Use!

Using this MCP server requires providing the MCP client with a FusionAuth API key. Only use this for dev and test instances. FusionAuth is not responsible for potentially leaking sensitive information.

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

For example, to add to Claude Desktop, edit `~/Library/Application Support/Claude/claude_desktop_config.json` to include the `fusionauth-api-server` below. If you don't have any previous MCP servers installed, it would look like this:

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
        "API_BASE_URL": "http://localhost:9011",
        "USE_TOOLS": "retrieve,search"
      }
    }
  }
}
```

You can omit the `env` section above if you have configured an `.env` file.

## Example Prompts

* "which tools do you have access to?" should show you all the FusionAuth API tools
* "how many fusionauth applications do I have?"
* "how many users do I have in my fusionauth instance?"
* "add a user with an email address of test@example.com and a password of 'password'"

## Restricting Tools

The default MCP Server has a tool for every API endpoint of FusionAuth. Over 300 of them!
However, the tools, descriptions, requests, and responses combine to nearly 200k tokens, 
which can exceed the context window of many MCP clients.

You can restrict which tools this MCP server makes available by setting the USE_TOOLS env 
variable as shown above.

Each tool is defined by its prefix. The default prefixes are:

* `create`
* `delete`
* `patch`
* `update`
* `retrieve`
* `search`

There is also an `other` tool bucket that contains every tool with another prefix.

For example, if you don't need to use any `delete` and `patch` methods, the following setting reduces the tool list by 20%.

```
USE_TOOLS="create,update,retrieve,search,other"
```

If you only want to use read operations, you can reduce the tool list by 66% by using the following configuration.
```
USE_TOOLS="retrieve,search"
```

## Troubleshooting

Verify your API key has correct permissions.

Check your MCP client logs. For example, `$HOME/Library/Logs/Claude/mcp-server-fusionauth-api-server.log`

Use the modelcontextprotocol inspector to help determine if the issue is the MCP server or your MCP client: `npx @modelcontextprotocol/inspector`
