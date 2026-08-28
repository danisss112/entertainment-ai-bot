#!/bin/bash
# =============================================================================
# AUTO DEPLOY SCRIPT FOR ENTERTAINMENT AI ASSISTANT
# =============================================================================

echo "🔄 Stashing any local changes & pulling latest from Git..."
git stash
git pull origin main

echo "🐳 Rebuilding and restarting Docker containers..."
docker compose up -d

echo "🧹 Cleaning up unused Docker images..."
docker image prune -f

echo "✅ Deployment completed successfully!"
