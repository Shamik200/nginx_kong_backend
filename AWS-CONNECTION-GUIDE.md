# AWS EC2 Connection Guide

## Step 1: Create/Download Your Key Pair

1. **Go to AWS Console** → **EC2** → **Key Pairs**
2. **Click "Create key pair"** or use existing one
3. **Settings:**
   - Name: `my-microservices-key` (or any name you prefer)
   - Key pair type: RSA
   - Private key file format: .pem
4. **Click "Create key pair"** - file downloads automatically
5. **Move the .pem file to a secure location:**
   ```powershell
   # Create .ssh directory if it doesn't exist
   mkdir C:\Users\$env:USERNAME\.ssh -Force
   
   # Move the key file (replace with your actual filename)
   Move-Item "C:\Users\$env:USERNAME\Downloads\my-microservices-key.pem" "C:\Users\$env:USERNAME\.ssh\"
   ```

## Step 2: Launch EC2 Instance

1. **Go to AWS Console** → **EC2** → **Launch Instance**
2. **Instance Configuration:**
   - **Name:** `microservices-app`
   - **AMI:** Amazon Linux 2023 (or Ubuntu 22.04 LTS)
   - **Instance type:** t3.medium (recommended) or t2.micro (free tier)
   - **Key pair:** Select the key you created above
   - **Security Group:** Create new with these rules:
     - SSH (22) - Your IP only
     - HTTP (80) - Anywhere (0.0.0.0/0)
     - Custom TCP (3001) - Anywhere
     - Custom TCP (3002) - Anywhere

3. **Click "Launch Instance"**

## Step 3: Find Your Instance Details

1. **Go to EC2** → **Instances**
2. **Click on your instance name**
3. **Copy the "Public IPv4 address"** (e.g., 54.123.45.67)

## Step 4: Connect to Your Instance

### Option A: Using PowerShell
```powershell
# Replace with your actual key path and IP address
ssh -i "C:\Users\$env:USERNAME\.ssh\my-microservices-key.pem" ec2-user@YOUR_EC2_PUBLIC_IP
```

### Option B: Using AWS Console Connect
1. Go to EC2 → Instances
2. Select your instance
3. Click "Connect"
4. Choose "EC2 Instance Connect"
5. Click "Connect" (opens in browser)

## Example Commands with Real Values

If your setup is:
- Key file: `my-microservices-key.pem` in your .ssh folder
- EC2 IP: `54.123.45.67`

Then your commands would be:

```powershell
# Connect to EC2
ssh -i "C:\Users\$env:USERNAME\.ssh\my-microservices-key.pem" ec2-user@54.123.45.67

# Clone your repository
git clone https://github.com/Shamik200/nginx_kong_backend.git

# Navigate to project
cd nginx_kong_backend/Pract-5

# Setup environment
chmod +x setup-ec2.sh
./setup-ec2.sh

# After logout/login, deploy
chmod +x deploy.sh
./deploy.sh
```

## Quick Reference Template

Fill in these values for your setup:

```
Key file location: C:\Users\[YOUR_USERNAME]\.ssh\[YOUR_KEY_NAME].pem
EC2 Public IP: [YOUR_EC2_PUBLIC_IP]
Repository URL: https://github.com/Shamik200/nginx_kong_backend.git
```

Your final SSH command:
```
ssh -i "C:\Users\[YOUR_USERNAME]\.ssh\[YOUR_KEY_NAME].pem" ec2-user@[YOUR_EC2_PUBLIC_IP]
```