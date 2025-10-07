# Microservices Deployment on AWS EC2

This guide will help you deploy your microservices application to AWS EC2.

## Prerequisites
- AWS Account
- AWS CLI installed and configured
- Git repository (recommended)
- SSH key pair for EC2 access

## Application Architecture
- User Service (FastAPI) - Port 3001
- Post Service (FastAPI) - Port 3002
- Nginx Reverse Proxy - Port 80

## Files Created for Deployment
- `docker-compose.prod.yml` - Production Docker Compose configuration
- `nginx.conf.prod` - Production Nginx configuration
- `deploy.sh` - Automated deployment script
- `requirements.txt` files for each service

## Deployment Steps
1. Launch EC2 Instance
2. Install Dependencies
3. Upload Code
4. Run Deployment Script
5. Test Application

## Endpoints After Deployment
- Health Check: `http://YOUR_EC2_IP/health`
- Users API: `http://YOUR_EC2_IP/users`
- Posts API: `http://YOUR_EC2_IP/posts`