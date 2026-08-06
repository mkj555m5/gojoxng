# GojoXNG - Privacy-respecting metasearch engine (based on SearXNG)
# Multi-stage Dockerfile ready for deployment on any web host
# License: AGPL-3.0-or-later

# ---------- Builder stage ----------
FROM docker.io/library/python:3.12-slim-bookworm AS builder

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        libxslt-dev \
        libxml2-dev \
        zlib1g-dev \
        libffi-dev \
        libssl-dev \
        git \
        && rm -rf /var/lib/apt/lists/*

# Create virtualenv and install GojoXNG (SearXNG fork)
WORKDIR /usr/local/searxng
COPY . /usr/local/searxng/

RUN python -m venv .venv \
    && .venv/bin/pip install --upgrade pip setuptools wheel \
    && .venv/bin/pip install --no-cache-dir . \
    && .venv/bin/pip install --no-cache-dir granian[pname]==2.7.9

# ---------- Runtime stage ----------
FROM docker.io/library/python:3.12-slim-bookworm AS dist

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    SEARXNG_BASE_URL="http://localhost:8080/" \
    SEARXNG_PORT=8080 \
    SEARXNG_BIND_ADDRESS="0.0.0.0" \
    SEARXNG_SECRET="" \
    __SEARXNG_CONFIG_PATH="/etc/searxng" \
    __SEARXNG_DATA_PATH="/var/cache/searxng" \
    SEARXNG_SETTINGS_PATH="/etc/searxng/settings.yml"

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
        libxslt1.1 \
        libxml2 \
        zlib1g \
        libffi8 \
        libssl3 \
        tini \
        && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --shell /bin/bash --uid 977 searxng

WORKDIR /usr/local/searxng

# Copy virtualenv from builder
COPY --chown=977:977 --from=builder /usr/local/searxng/.venv ./.venv
COPY --chown=977:977 ./searx ./searx
COPY --chown=977:977 ./container ./container
COPY --chown=977:977 ./requirements.txt ./requirements.txt

# Set up config and data directories
RUN mkdir -p /etc/searxng /var/cache/searxng \
    && chown -R 977:977 /etc/searxng /var/cache/searxng

ENV PATH="/usr/local/searxng/.venv/bin:${PATH}"

USER searxng

EXPOSE 8080

ENTRYPOINT ["/usr/bin/tini", "--", "/usr/local/searxng/container/entrypoint.sh"]
