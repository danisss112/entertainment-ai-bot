#!/bin/bash
# =============================================================================
# AUTO DEPLOY SCRIPT FOR ENTERTAINMENT AI ASSISTANT
# =============================================================================

echo "🔄 Pulling latest changes from Git repository..."
git pull origin main

echo "🐳 Rebuilding and restarting Docker containers..."
docker compose up -d

echo "🧹 Cleaning up unused Docker images..."
docker image prune -f

echo "✅ Deployment completed successfully!"
