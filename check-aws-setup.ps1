# PowerShell script to help find your AWS EC2 connection details

Write-Host "🔍 AWS EC2 Connection Helper" -ForegroundColor Green
Write-Host "================================" -ForegroundColor Green
Write-Host ""

# Check for existing SSH keys
Write-Host "🔑 Checking for existing SSH keys..." -ForegroundColor Yellow
$sshPath = "$env:USERPROFILE\.ssh"
if (Test-Path $sshPath) {
    Write-Host "✅ .ssh directory found at: $sshPath" -ForegroundColor Green
    $pemFiles = Get-ChildItem -Path $sshPath -Filter "*.pem" -ErrorAction SilentlyContinue
    if ($pemFiles) {
        Write-Host "📝 Found .pem files:" -ForegroundColor Green
        foreach ($file in $pemFiles) {
            Write-Host "   - $($file.Name)" -ForegroundColor White
        }
    } else {
        Write-Host "❌ No .pem files found in .ssh directory" -ForegroundColor Red
    }
} else {
    Write-Host "❌ .ssh directory not found" -ForegroundColor Red
    Write-Host "💡 Creating .ssh directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $sshPath -Force | Out-Null
    Write-Host "✅ Created: $sshPath" -ForegroundColor Green
}

Write-Host ""

# Check Downloads folder for .pem files
Write-Host "📁 Checking Downloads folder for .pem files..." -ForegroundColor Yellow
$downloadsPath = "$env:USERPROFILE\Downloads"
$downloadsPemFiles = Get-ChildItem -Path $downloadsPath -Filter "*.pem" -ErrorAction SilentlyContinue
if ($downloadsPemFiles) {
    Write-Host "📥 Found .pem files in Downloads:" -ForegroundColor Green
    foreach ($file in $downloadsPemFiles) {
        Write-Host "   - $($file.Name)" -ForegroundColor White
    }
    Write-Host ""
    Write-Host "💡 Suggestion: Move these to your .ssh folder:" -ForegroundColor Yellow
    foreach ($file in $downloadsPemFiles) {
        Write-Host "   Move-Item `"$($file.FullName)`" `"$sshPath\`"" -ForegroundColor Cyan
    }
} else {
    Write-Host "❌ No .pem files found in Downloads" -ForegroundColor Red
}

Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Yellow
Write-Host "1. If you don't have a .pem key file:" -ForegroundColor White
Write-Host "   → Go to AWS Console → EC2 → Key Pairs → Create key pair" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Launch EC2 instance:" -ForegroundColor White
Write-Host "   → AWS Console → EC2 → Launch Instance" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Get your EC2 public IP:" -ForegroundColor White
Write-Host "   → AWS Console → EC2 → Instances → Select your instance" -ForegroundColor Cyan
Write-Host "   → Copy 'Public IPv4 address'" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Your SSH command template:" -ForegroundColor White
Write-Host "   ssh -i `"$sshPath\YOUR_KEY_NAME.pem`" ec2-user@YOUR_EC2_PUBLIC_IP" -ForegroundColor Cyan
Write-Host ""

# Check AWS CLI
Write-Host "🔧 Checking AWS CLI..." -ForegroundColor Yellow
try {
    $awsVersion = aws --version 2>$null
    if ($awsVersion) {
        Write-Host "✅ AWS CLI installed: $awsVersion" -ForegroundColor Green
    } else {
        Write-Host "❌ AWS CLI not found" -ForegroundColor Red
        Write-Host "💡 Install from: https://aws.amazon.com/cli/" -ForegroundColor Yellow
    }
} catch {
    Write-Host "❌ AWS CLI not found" -ForegroundColor Red
    Write-Host "💡 Install from: https://aws.amazon.com/cli/" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "🚀 Ready to deploy? Your repository is at:" -ForegroundColor Green
Write-Host "   https://github.com/Shamik200/nginx_kong_backend.git" -ForegroundColor Cyan

Read-Host -Prompt "Press Enter to continue"