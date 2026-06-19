FROM python:3.12-slim

# Install Node.js (needed for supergateway, the stdio->SSE bridge)
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates gnupg \
    && curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install the official Google Analytics MCP server (stdio) + the SSE bridge
RUN pip install --no-cache-dir analytics-mcp \
    && npm install -g supergateway

WORKDIR /app
COPY start.sh /app/start.sh
RUN chmod +x /app/start.sh

CMD ["/app/start.sh"]
