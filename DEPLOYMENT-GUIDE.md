# Complete AWS EC2 Deployment Guide

## Method 1: Using Git Repository (Recommended)

### Step 1: Push Your Code to Git Repository

1. **Initialize Git repository (if not done already):**
   ```powershell
   cd c:\Codes\CNADevOps\Pract-5
   git init
   git add .
   git commit -m "Initial commit - microservices app"
   ```

2. **Create GitHub repository and push:**
   ```powershell
   # Create repository on GitHub, then:
   git remote add origin https://github.com/yourusername/your-repo-name.git
   git branch -M main
   git push -u origin main
   ```

### Step 2: Launch EC2 Instance

1. **Go to AWS Console → EC2 → Launch Instance**
2. **Configuration:**
   - **AMI:** Amazon Linux 2 or Ubuntu 20.04 LTS
   - **Instance Type:** t3.medium (recommended) or t3.small (for testing)
   - **Key Pair:** Create/select your SSH key pair
   - **Security Group:** Create with these rules:
     - SSH (22) - Your IP only
     - HTTP (80) - Anywhere (0.0.0.0/0)
     - Custom TCP (3001) - Anywhere (for direct user-service access)
     - Custom TCP (3002) - Anywhere (for direct post-service access)

3. **Launch the instance**

### Step 3: Connect to EC2

```powershell
# From your local machine
ssh -i "your-key.pem" ec2-user@your-ec2-public-ip
```

### Step 4: Setup EC2 Environment

```bash
# On EC2 instance
wget https://raw.githubusercontent.com/yourusername/your-repo/main/Pract-5/setup-ec2.sh
chmod +x setup-ec2.sh
./setup-ec2.sh

# Logout and login again
exit
```

### Step 5: Deploy Your Application

```bash
# After reconnecting to EC2
git clone https://github.com/yourusername/your-repo.git
cd your-repo/Pract-5

# Make deployment script executable
chmod +x deploy.sh

# Deploy the application
./deploy.sh
```

## Method 2: Direct File Upload

### Upload Files Using SCP

```powershell
# From your local Windows machine
scp -i "your-key.pem" -r "c:\Codes\CNADevOps\Pract-5" ec2-user@your-ec2-public-ip:~/
```

Then follow steps 4-5 from Method 1.

## Method 3: Using AWS CLI and S3 (Alternative)

### Upload to S3 and Download on EC2

```powershell
# From local machine
aws s3 cp "c:\Codes\CNADevOps\Pract-5" s3://your-bucket/pract-5/ --recursive
```

```bash
# On EC2
aws s3 cp s3://your-bucket/pract-5/ ~/Pract-5/ --recursive
cd ~/Pract-5
chmod +x *.sh
./setup-ec2.sh
# Logout/login, then:
./deploy.sh
```

## Testing Your Deployment

After successful deployment, test your application:

```bash
# Get your EC2 public IP
curl -s ifconfig.me

# Test endpoints (replace YOUR_EC2_IP with actual IP)
curl http://YOUR_EC2_IP/health
curl http://YOUR_EC2_IP/users
curl http://YOUR_EC2_IP/posts

# Test POST request
curl -X POST http://YOUR_EC2_IP/posts \
  -H "Content-Type: application/json" \
  -d '{"title":"Test from EC2","content":"Deployed successfully!","userId":1}'
```

## Monitoring and Management

### View Application Logs
```bash
cd ~/Pract-5  # or your-repo/Pract-5
docker-compose -f docker-compose.prod.yml logs -f
```

### Restart Services
```bash
docker-compose -f docker-compose.prod.yml restart
```

### Update Application
```bash
git pull origin main
./deploy.sh
```

### Stop Application
```bash
docker-compose -f docker-compose.prod.yml down
```

## Security Best Practices

1. **Update Security Group:** Remove direct access to ports 3001, 3002 after testing
2. **Use HTTPS:** Add SSL certificate
3. **Regular Updates:** Keep EC2 and Docker updated
4. **Monitoring:** Set up CloudWatch
5. **Backup:** Regular data backups

## Troubleshooting

### Common Issues:

1. **Docker Permission Denied:**
   ```bash
   sudo usermod -a -G docker $USER
   # Logout and login again
   ```

2. **Port Already in Use:**
   ```bash
   docker-compose -f docker-compose.prod.yml down
   docker system prune -f
   ```

3. **Build Failures:**
   ```bash
   docker-compose -f docker-compose.prod.yml build --no-cache
   ```

4. **Service Not Responding:**
   ```bash
   docker logs user-service
   docker logs post-service
   docker logs nginx-proxy
   ```

## Cost Optimization

- Use **t3.micro** for development (Free Tier eligible)
- Use **t3.small/medium** for production
- Stop instance when not needed
- Use Elastic IP only if required
- Monitor costs with AWS Cost Explorer