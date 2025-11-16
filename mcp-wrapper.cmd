@echo off
docker exec -i n8n-mcp-server node /app/dist/mcp/index.js 2>nul
