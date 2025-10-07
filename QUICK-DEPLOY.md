# Quick Deploy Commands for AWS Learner Lab

## One-Line Deployment (Copy & Paste into EC2 Instance Connect):

```bash
curl -sSL https://raw.githubusercontent.com/Shamik200/nginx_kong_backend/main/Pract-5/deploy-learner-lab.sh | bash
```

## Manual Step-by-Step (if the above doesn't work):

### Step 1: Connect to EC2
1. AWS Console → EC2 → Instances
2. Select your instance → Connect → EC2 Instance Connect → Connect

### Step 2: Run these commands one by one:

```bash
# Install Docker and tools
sudo yum update -y
sudo yum install -y docker git curl
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone repository
git clone https://github.com/Shamik200/nginx_kong_backend.git
cd nginx_kong_backend/Pract-5

# Deploy application
chmod +x deploy-learner-lab.sh
newgrp docker << 'EOF'
./deploy-learner-lab.sh
EOF
```

### Step 3: Get your application URL
```bash
echo "Your app: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)"
```

## Testing Your Application

Replace `YOUR_EC2_IP` with your actual EC2 public IP:

```bash
# Health check
curl http://YOUR_EC2_IP/health

# Get users
curl http://YOUR_EC2_IP/users

# Get posts
curl http://YOUR_EC2_IP/posts

# Create a new post
curl -X POST http://YOUR_EC2_IP/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Hello from AWS","content":"Deployed successfully!","userId":1}'
```

## Troubleshooting

### Check container status:
```bash
cd nginx_kong_backend/Pract-5
docker-compose -f docker-compose.prod.yml ps
```

### View logs:
```bash
docker-compose -f docker-compose.prod.yml logs -f
```

### Restart services:
```bash
docker-compose -f docker-compose.prod.yml restart
```

### Stop application:
```bash
docker-compose -f docker-compose.prod.yml down
```