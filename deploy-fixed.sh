#!/bin/bash
# Fixed deployment script for Ubuntu with older Docker Compose

echo "🐧 Ubuntu EC2 Deployment - Fixed Version"
echo "========================================"

# Check if we need to fix permissions
if ! docker ps >/dev/null 2>&1; then
    echo "🔧 Fixing Docker permissions..."
    sudo usermod -aG docker ubuntu
    echo "⚠️  You need to logout and login again for Docker permissions to take effect"
    echo "   After logout/login, run this script again"
    echo ""
    echo "   For now, we'll use sudo with Docker commands"
    USE_SUDO="sudo "
else
    USE_SUDO=""
fi

echo "🛑 Stopping existing containers..."
${USE_SUDO}docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

echo "🗑️ Cleaning up old images..."
${USE_SUDO}docker system prune -f 2>/dev/null || true

echo "🔨 Building and starting services..."
${USE_SUDO}docker-compose -f docker-compose.prod.yml up --build -d

echo "⏳ Waiting for services to start..."
sleep 15

echo "🧪 Testing services..."
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

echo "📍 Your EC2 Public IP: $PUBLIC_IP"
echo ""
echo "🔗 Your application URLs:"
echo "  Health Check: http://$PUBLIC_IP/health"
echo "  Users API:    http://$PUBLIC_IP/users"
echo "  Posts API:    http://$PUBLIC_IP/posts"
echo ""

# Test local endpoints
echo "🔍 Testing local endpoints..."
curl -s http://localhost/health && echo "✅ Health check: OK" || echo "❌ Health check: Failed"
curl -s http://localhost/users > /dev/null && echo "✅ Users API: OK" || echo "❌ Users API: Failed"
curl -s http://localhost/posts > /dev/null && echo "✅ Posts API: OK" || echo "❌ Posts API: Failed"

echo ""
echo "📋 Container status:"
${USE_SUDO}docker-compose -f docker-compose.prod.yml ps

echo ""
echo "🎉 Deployment completed!"
echo "🌐 Access your application at: http://$PUBLIC_IP"

echo ""
echo "📝 Management commands:"
echo "  View logs: ${USE_SUDO}docker-compose -f docker-compose.prod.yml logs -f"
echo "  Stop app:  ${USE_SUDO}docker-compose -f docker-compose.prod.yml down"
echo "  Restart:   ${USE_SUDO}docker-compose -f docker-compose.prod.yml restart"