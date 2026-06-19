#!/usr/bin/env bash
set -euo pipefail

# Write the GA4 service-account key (stored as a Railway env var) to a file
# that the analytics-mcp server can read.
if [ -n "${GOOGLE_APPLICATION_CREDENTIALS_JSON:-}" ]; then
  echo "$GOOGLE_APPLICATION_CREDENTIALS_JSON" > /app/key.json
  export GOOGLE_APPLICATION_CREDENTIALS=/app/key.json
fi

# Railway injects PORT and RAILWAY_PUBLIC_DOMAIN automatically.
PORT="${PORT:-8000}"
if [ -n "${RAILWAY_PUBLIC_DOMAIN:-}" ]; then
  BASE_URL="https://${RAILWAY_PUBLIC_DOMAIN}"
else
  BASE_URL="http://localhost:${PORT}"
fi

# Run the GA4 stdio MCP server behind an SSE endpoint so Cowork can
# connect to it by URL (same pattern as the CallRail server).
exec supergateway \
  --stdio "analytics-mcp" \
  --port "$PORT" \
  --baseUrl "$BASE_URL" \
  --ssePath /sse \
  --messagePath /message \
  --healthEndpoint /healthz \
  --cors
