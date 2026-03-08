#!/bin/bash
set -e

# Ensure we are in the project root
cd "$(dirname "$0")/.."

echo "[DEPLOY] Starting Deployment Process..."

# 1. Pull latest code (if remote exists)
echo "[DEPLOY] Checking for updates..."
if git remote | grep -q origin; then
    echo "[DEPLOY] Pulling latest code..."
    git pull origin main || echo "[WARN] Git pull failed, using local changes"
else
    echo "[INFO] No remote 'origin' configured. Skipping git pull."
fi

# 2. Cleanup conflicting containers (e.g. from Jenkins or previous runs)
echo "[DEPLOY] Cleaning up old containers..."
# Stop and remove any container named 'aceest-app' (used by Jenkins)
docker stop aceest-app 2>/dev/null || true
docker rm aceest-app 2>/dev/null || true

# 3. Build and Run with Docker Compose
echo "[DEPLOY] Building and Starting Services..."
docker compose up -d --build

# 3. Wait for Healthcheck
echo "[DEPLOY] Waiting for healthcheck..."
sleep 10
status=$(docker inspect --format='{{json .State.Health.Status}}' $(docker compose ps -q aceest-app))
echo "Health Status: $status"

if [ "$status" == "\"healthy\"" ] || [ "$status" == "\"starting\"" ]; then
    echo "[DEPLOY] Service is running."
else
    echo "[DEPLOY] Service health check failed or still starting."
    docker compose logs
fi

echo "[DEPLOY] Complete. App running on port 5001"
