#!/bin/bash
# EC2 Setup Script for Microservices Application

echo "🚀 Setting up EC2 instance for microservices deployment..."

# Update system
echo "📦 Updating system packages..."
if [ -f /etc/redhat-release ]; then
    # Amazon Linux
    sudo yum update -y
    sudo yum install -y git curl
elif [ -f /etc/debian_version ]; then
    # Ubuntu/Debian
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y git curl
fi

# Install Docker
echo "🐳 Installing Docker..."
if [ -f /etc/redhat-release ]; then
    # Amazon Linux
    sudo yum install -y docker
    sudo service docker start
    sudo systemctl enable docker
elif [ -f /etc/debian_version ]; then
    # Ubuntu/Debian
    sudo apt install -y docker.io
    sudo systemctl start docker
    sudo systemctl enable docker
fi

# Add user to docker group
sudo usermod -a -G docker $USER

# Install Docker Compose
echo "🔧 Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create symbolic link for docker-compose
sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "✅ EC2 setup completed!"
echo "📝 Please logout and login again to apply docker group permissions"
echo "🔄 Run: exit, then reconnect via SSH"
echo ""
echo "After reconnecting, clone your repository and run the deployment script:"
echo "git clone <your-repo-url>"
echo "cd <your-repo>/Pract-5"
echo "./deploy.sh"