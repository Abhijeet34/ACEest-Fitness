#!/bin/bash
set -e

echo "[DEPLOY] Starting Deployment Process..."

# 1. Pull latest code
echo "[DEPLOY] Pulling latest code..."
git pull origin main

# 2. Build Docker Image
echo "[DEPLOY] Building Docker Image..."
docker build -t aceest-fitness:latest .

# 3. Stop existing container
echo "[DEPLOY] Stopping existing container..."
docker stop aceest-app || true
docker rm aceest-app || true

# 4. Run new container
echo "[DEPLOY] Running new container..."
docker run -d -p 5000:5000 --name aceest-app --restart always aceest-fitness:latest

echo "[DEPLOY] Complete. App running on port 5000"
