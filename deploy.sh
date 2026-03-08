#!/bin/bash
set -e

echo "[DEPLOY] Starting Deployment Process..."

# 1. Pull latest code
echo "[DEPLOY] Pulling latest code..."
git pull origin main || echo "[WARN] Git pull failed, using local changes"

# 2. Build and Run with Docker Compose
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
