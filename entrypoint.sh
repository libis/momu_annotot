#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/annotot_app/pids/server.pid

if [ ! -f "/app/annotot_app/db/production.sqlite3" ]; then
  rails db:migrate
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
