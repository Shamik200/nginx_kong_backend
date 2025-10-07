#!/bin/bash

echo "🚀 Starting deployment process..."

# Stop existing containers
echo "🛑 Stopping existing containers..."
docker-compose -f docker-compose.prod.yml down

# Remove old images
echo "🗑️ Cleaning up old images..."
docker system prune -f

# Build and start services
echo "🔨 Building and starting services..."
docker-compose -f docker-compose.prod.yml up --build -d

# Check if services are running
echo "✅ Checking service health..."
sleep 10

# Test endpoints
echo "🧪 Testing endpoints..."
echo "Testing nginx health check..."
curl -f http://localhost/health || echo "❌ Health check failed"

echo "Testing user service..."
curl -f http://localhost/users || echo "❌ User service test failed"

echo "Testing post service..."
curl -f http://localhost/posts || echo "❌ Post service test failed"

echo "📋 Container status:"
docker-compose -f docker-compose.prod.yml ps

echo "🎉 Deployment completed!"
echo "Your application is available at: http://$(curl -s ifconfig.me)"