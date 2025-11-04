# Preview FusionAuth API MCP Server (fusionauth-mcp-api)

[![npm version](https://img.shields.io/npm/v/@fusionauth/mcp-api.svg)](https://www.npmjs.com/package/@fusionauth/mcp-api)
[![License: Apache](https://img.shields.io/badge/License-Apache-yellow.svg)](https://opensource.org/license/apache-2-0)
[![GitHub repository](https://img.shields.io/badge/GitHub-FusionAuth/fusionauth--mcp--api-blue.svg)](https://github.com/FusionAuth/fusionauth-mcp-api)

Preview MCP server for the FusionAuth API.
Built with the excellent [github.com/harsha-iiiv/openapi-mcp-generator](https://github.com/harsha-iiiv/openapi-mcp-generator)

## ⚠️  Not for Production Use!

Using this MCP server requires providing the MCP client with a FusionAuth API key. Only use this for dev and test instances. FusionAuth is not responsible for potentially leaking sensitive information.

<!--
tag::forDocSite[]
-->

## Prerequisites

* A running FusionAuth instance
* Node.js

## Configuration

First, set up a limited API key in the FusionAuth instance. Here's documentation on [creating an API key](https://fusionauth.io/docs/apis/authentication#create-an-api-key) and [configuring the correct permissions for an API key](https://fusionauth.io/docs/apis/authentication#api-key-permissions).

Next, configure your MCP client to use the FusionAuth API MCP server.

For example, to add to Claude Desktop, edit `~/Library/Application Support/Claude/claude_desktop_config.json` to include the `fusionauth-mcp-api` below. If you don't have any previous MCP servers installed, it would look like this:

```json
{
  "mcpServers": {
      "fusionauth-mcp-api": {
      "command": "npx",
      "args": [
        "@fusionauth/mcp-api"
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

The `USE_TOOLS` env variable above essentially restricts the available tools to read only operations. You can omit this value to provide full read write access, but you will need a model that can handle about 200k tokens.

Consult your MCP client documentation to determine how to add an MCP server to your client.

## Example Prompts

* "which tools do you have access to?" should show you all the FusionAuth API tools
* "how many fusionauth applications do I have?"
* "how many users do I have in my fusionauth instance?"
* "add a user with an email address of test@example.com and a password of 'password'" (requires less restricted tools)

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

## Securing Your MCP Server

There are three different approaches to secure your MCP server and you should combine them to enable secure access to your FusionAuth instance while still meeting your functionality needs. In order of granularity (from low to high):

* Point to the correct instance. This tool is in preview and we suggest you only point it at a local, dev instance.
* Enable the correct type of tools. In addition to reducing context window usage, limiting the type of requests your LLM can make can increase security. For instance, if you don't enable the `delete` set of tools, you don't have to worry about the LLM "helping" you by deleting FusionAuth configuration.
* Lock down your API key. This allows fine grained control beyond the tool choice. The MCP server communicates to FusionAuth using an API key. You can limit that API key to only allow it to act on tenants, applications and users by choosing the [appropriate set of permissions](https://fusionauth.io/docs/apis/authentication#api-key-permissions). 

## Troubleshooting

Verify your API key has correct permissions.

Check your MCP client logs. For example, `$HOME/Library/Logs/Claude/mcp-server-fusionauth-api-server.log`

Use the modelcontextprotocol inspector to help determine if the issue is the MCP server or your MCP client: `npx @modelcontextprotocol/inspector`. If you want to change the `USE_TOOLS` variable, you cannot dynamically change it and must pass it on the command line. `npx @modelcontextprotocol/inspector npx @fusionauth/mcp-api -e API_KEY_APIKEYAUTH=... -e USE_TOOLS=create`

<!--
end::forDocSite[]
-->

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

## Feedback

Please share feature requests and bugs in this repo.

If you want to share interesting use cases or ask how to use functionality, please post in [the FusionAuth forum](https://fusionauth.io/community/forum/).
