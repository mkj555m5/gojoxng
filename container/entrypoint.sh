#!/bin/sh
# shellcheck shell=dash
set -u

# GojoXNG entrypoint - starts the privacy-respecting metasearch engine

CONFIG_PATH="${__SEARXNG_CONFIG_PATH:-/etc/searxng}"
DATA_PATH="${__SEARXNG_DATA_PATH:-/var/cache/searxng}"
SETTINGS_FILE="$CONFIG_PATH/settings.yml"
TEMPLATE_FILE="/usr/local/searxng/container/settings.template.yml"

echo "GojoXNG - Privacy-respecting metasearch engine"
echo "Config path: $CONFIG_PATH"
echo "Data path:   $DATA_PATH"

# Ensure directories exist
mkdir -p "$CONFIG_PATH" "$DATA_PATH" 2>/dev/null || true

# If settings.yml does not exist, create from template
if [ ! -f "$SETTINGS_FILE" ]; then
    if [ -f "$TEMPLATE_FILE" ]; then
        echo "... creating settings.yml from template"
        cp -f "$TEMPLATE_FILE" "$SETTINGS_FILE"
    else
        echo "... creating minimal settings.yml"
        cat > "$SETTINGS_FILE" <<'YAML'
use_default_settings: true

general:
  instance_name: "GojoXNG"
  enable_metrics: false

server:
  secret_key: "REPLACE_ME"
  image_proxy: true
  method: "POST"
  http_protocol_version: "1.1"
  default_http_headers:
    X-Content-Type-Options: nosniff
    X-Robots-Tag: "noindex, nofollow"
    Referrer-Policy: no-referrer
YAML
    fi
fi

# Generate a random secret key if SEARXNG_SECRET is set, or replace placeholder
if [ -n "${SEARXNG_SECRET:-}" ] && [ "$SEARXNG_SECRET" != "" ]; then
    sed -i "s/REPLACE_ME/$SEARXNG_SECRET/g" "$SETTINGS_FILE" 2>/dev/null || true
    sed -i "s/REPLACE_WITH_GOJOXNG_SECRET_ENV/$SEARXNG_SECRET/g" "$SETTINGS_FILE" 2>/dev/null || true
    sed -i "s/ultrasecretkey/$SEARXNG_SECRET/g" "$SETTINGS_FILE" 2>/dev/null || true
elif grep -q "REPLACE_ME\|REPLACE_WITH_GOJOXNG_SECRET_ENV\|ultrasecretkey" "$SETTINGS_FILE" 2>/dev/null; then
    echo "... generating random secret key"
    RANDOM_KEY=$(head -c 32 /dev/urandom | base64 | tr -dc 'a-zA-Z0-9' | head -c 32)
    sed -i "s/REPLACE_ME/$RANDOM_KEY/g" "$SETTINGS_FILE" 2>/dev/null || true
    sed -i "s/REPLACE_WITH_GOJOXNG_SECRET_ENV/$RANDOM_KEY/g" "$SETTINGS_FILE" 2>/dev/null || true
    sed -i "s/ultrasecretkey/$RANDOM_KEY/g" "$SETTINGS_FILE" 2>/dev/null || true
fi

# Set port from environment
case "${SEARXNG_PORT:-}" in
    '') ;;
    *[!0-9]*) unset SEARXNG_PORT ;;
    *) export GRANIAN_PORT="$SEARXNG_PORT" ;;
esac

echo "... starting GojoXNG on port ${SEARXNG_PORT:-8080}"
exec /usr/local/searxng/.venv/bin/granian searx.webapp:app
