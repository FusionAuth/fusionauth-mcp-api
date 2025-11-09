#!/bin/bash

# bumps version in the package.json
npm version patch

npm run build:openapi-mcp-generator
npm run build:mcp-api
npm run generate

## todo, commit version
