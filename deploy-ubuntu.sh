#!/bin/bash
# Ubuntu deployment script for AWS EC2

echo "🐧 Ubuntu EC2 Deployment Script"
echo "==============================="

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    echo "⚠️  Please run as ubuntu user, not root"
    exit 1
fi

echo "📦 Step 1: Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

echo "🐳 Step 2: Installing Docker..."
# Remove any old Docker versions
sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

echo "🔧 Step 3: Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "✅ Step 4: Verifying installations..."
docker --version
docker-compose --version

echo "🚀 Step 5: Starting application..."
# Stop any existing containers
sudo docker-compose -f docker-compose.prod.yml down 2>/dev/null || true

# Build and start services (with sudo temporarily)
sudo docker-compose -f docker-compose.prod.yml up --build -d

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
sudo docker-compose -f docker-compose.prod.yml ps

echo ""
echo "🎉 Deployment completed!"
echo "🌐 Access your application at: http://$PUBLIC_IP"

# Show how to check logs
echo ""
echo "📝 To check logs:"
echo "  sudo docker-compose -f docker-compose.prod.yml logs -f"
echo ""
echo "🛑 To stop application:"
echo "  sudo docker-compose -f docker-compose.prod.yml down"
echo ""
echo "⚠️  Note: After logout/login, you can use docker without sudo"