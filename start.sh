#!/usr/bin/env bash
set -euo pipefail

# Write the GA4 service-account key (stored as a Railway env var) to a file
# that the analytics-mcp server can read.
if [ -n "${GOOGLE_APPLICATION_CREDENTIALS_JSON:-}" ]; then
  echo "$GOOGLE_APPLICATION_CREDENTIALS_JSON" > /app/key.json
  export GOOGLE_APPLICATION_CREDENTIALS=/app/key.json
fi

# Railway injects PORT automatically.
PORT="${PORT:-8000}"

# Serve the GA4 stdio MCP server over the modern Streamable HTTP transport at
# /mcp so Cowork and Claude Code connect reliably. --stateful keeps one warm
# session bound to the single stdio child.
exec supergateway \
  --stdio "analytics-mcp" \
  --outputTransport streamableHttp \
  --streamableHttpPath /mcp \
  --stateful \
  --port "$PORT" \
  --healthEndpoint /healthz \
  --cors
