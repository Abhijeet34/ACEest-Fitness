#!/bin/bash
set -e

echo "🚀 Starting Deployment Process..."

# 1. Pull latest code (simulated)
echo "📦 Pulling latest code..."
git pull origin main

# 2. Build Docker Image
echo "🔨 Building Docker Image..."
docker build -t aceest-fitness:latest .

# 3. Stop existing container
echo "🛑 Stopping existing container..."
docker stop aceest-app || true
docker rm aceest-app || true

# 4. Run new container
echo "▶️ Running new container..."
docker run -d -p 5000:5000 --name aceest-app --restart always aceest-fitness:latest

echo "✅ Deployment Complete! App running on port 5000"
