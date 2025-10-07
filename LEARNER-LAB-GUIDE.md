# AWS Learner Lab Deployment Guide

## Important: You're using AWS Learner Lab (voclabs)

AWS Learner Lab has restricted permissions, but you can still deploy your application!

## Step 1: Find Existing Key Pairs

1. **Go to AWS Console → EC2 → Key Pairs**
2. **Look for existing key pairs** (usually named like `vockey` or similar)
3. **If you see a key pair, download it:**
   - Select the key pair
   - Click "Actions" → "Export key pair" (if available)
   - OR use the existing one if you already have it

## Step 2: Alternative - Use EC2 Instance Connect (Recommended for Learner Lab)

Since you can't create key pairs, use **EC2 Instance Connect** instead:

1. **Launch EC2 Instance:**
   - AMI: Amazon Linux 2023
   - Instance type: t2.micro (free tier)
   - **Key pair: Select existing one or choose "Proceed without key pair"**
   - Security Group: Allow HTTP (80), SSH (22), and custom ports 3001, 3002

2. **Connect via Browser:**
   - Go to EC2 → Instances
   - Select your instance
   - Click "Connect"
   - Choose "EC2 Instance Connect"
   - Click "Connect" (opens terminal in browser)

## Step 3: Deploy Using Browser Terminal

Once connected via EC2 Instance Connect:

```bash
# Update system
sudo yum update -y

# Install Docker
sudo yum install -y docker git
sudo service docker start
sudo usermod -a -G docker ec2-user

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Clone your repository
git clone https://github.com/Shamik200/nginx_kong_backend.git

# Navigate to project
cd nginx_kong_backend/Pract-5

# Make scripts executable
chmod +x *.sh

# Deploy application
./deploy.sh
```

## Step 4: Access Your Application

After deployment, get your EC2 public IP:
- AWS Console → EC2 → Instances → Your instance → Public IPv4 address

Test endpoints:
- Health: `http://YOUR_EC2_IP/health`
- Users: `http://YOUR_EC2_IP/users`
- Posts: `http://YOUR_EC2_IP/posts`

## Alternative: Use Existing Lab Keys

Check if your lab environment has pre-configured keys:

1. **Look in your lab instructions** for key pair information
2. **Common names in Learner Lab:**
   - `vockey`
   - `labsuser-key`
   - `default-key`

If you find an existing key, download it and use:
```powershell
ssh -i "path\to\existing-key.pem" ec2-user@your-ec2-ip
```