@echo off
REM Windows PowerShell script to help with AWS EC2 deployment

echo "🚀 AWS EC2 Deployment Helper"
echo "================================"
echo ""

echo "Step 1: Make sure you have AWS CLI installed and configured"
echo "If not installed, download from: https://aws.amazon.com/cli/"
echo ""

echo "Step 2: Check AWS CLI configuration"
aws --version
echo ""

echo "Step 3: Your project is ready for deployment!"
echo "Files prepared:"
echo "- docker-compose.prod.yml (Production configuration)"
echo "- nginx.conf.prod (Production nginx config)"
echo "- deploy.sh (Deployment script)"
echo "- setup-ec2.sh (EC2 setup script)"
echo ""

echo "Next steps:"
echo "1. Launch EC2 instance in AWS Console"
echo "2. Upload your code to EC2"
echo "3. Run setup-ec2.sh on EC2"
echo "4. Run deploy.sh to deploy your application"
echo ""

pause