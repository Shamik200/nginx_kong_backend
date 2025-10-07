#!/bin/bash
# Simplified deployment script for AWS Learner Lab

echo "🎓 AWS Learner Lab Deployment Script"
echo "====================================="

# Check if running as root (EC2 Instance Connect runs as ec2-user)
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Please run as ec2-user, not root"
    exit 1
fi

echo "📦 Step 1: Installing system updates..."
sudo yum update -y

echo "🐳 Step 2: Installing Docker..."
sudo yum install -y docker git curl
sudo service docker start
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

echo "🔧 Step 3: Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "✅ Step 4: Verifying installations..."
docker --version
docker-compose --version

echo "🚀 Step 5: Starting application..."
# Stop any existing containers
docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Build and start services
docker-compose -f docker-compose.prod.yml up --build -d

echo "⏳ Step 6: Waiting for services to start..."
sleep 15

echo "🧪 Step 7: Testing services..."
# Get EC2 public IP
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
docker-compose -f docker-compose.prod.yml ps

echo ""
echo "🎉 Deployment completed!"
echo "🌐 Access your application at: http://$PUBLIC_IP"

# Show how to check logs
echo ""
echo "📝 To check logs:"
echo "  docker-compose -f docker-compose.prod.yml logs -f"
echo ""
echo "🛑 To stop application:"
echo "  docker-compose -f docker-compose.prod.yml down"