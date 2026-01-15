#!/bin/bash

# n8n WhatsApp Setup Quick Start Script
# This script helps you quickly set up n8n with WhatsApp integration

set -e

echo "=================================================="
echo "n8n WhatsApp Integration - Quick Start"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed.${NC}"
    echo "Please install Docker first: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null 2>&1; then
    echo -e "${RED}Error: Docker Compose is not installed.${NC}"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo -e "${GREEN}✓ Docker and Docker Compose are installed${NC}"
echo ""

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env file...${NC}"
    
    # Prompt for domain
    read -p "Enter your domain name (e.g., n8n.yourdomain.com): " domain
    
    # Prompt for credentials
    read -p "Enter n8n admin username [admin]: " n8n_user
    n8n_user=${n8n_user:-admin}
    
    read -sp "Enter n8n admin password: " n8n_password
    echo ""
    
    # Generate encryption key
    encryption_key=$(openssl rand -base64 32 | tr -d "=+/" | cut -c1-32)
    
    # Prompt for WhatsApp details
    echo ""
    echo "Enter WhatsApp API credentials (you can skip and add later):"
    read -p "WhatsApp Phone Number ID: " whatsapp_phone_id
    read -p "WhatsApp Access Token: " whatsapp_token
    read -p "Webhook Verify Token (create a secret): " verify_token
    verify_token=${verify_token:-mySecretToken123}
    
    # Create .env file
    cat > .env << EOF
# n8n Configuration
N8N_HOST=${domain}
TIMEZONE=Europe/Berlin
N8N_USER=${n8n_user}
N8N_PASSWORD=${n8n_password}
N8N_ENCRYPTION_KEY=${encryption_key}

# Database
POSTGRES_USER=n8n
POSTGRES_PASSWORD=$(openssl rand -base64 16)
POSTGRES_DB=n8n
POSTGRES_NON_ROOT_USER=n8n
POSTGRES_NON_ROOT_PASSWORD=$(openssl rand -base64 16)

# WhatsApp
WHATSAPP_PHONE_NUMBER_ID=${whatsapp_phone_id}
WHATSAPP_ACCESS_TOKEN=${whatsapp_token}
WHATSAPP_VERIFY_TOKEN=${verify_token}
EOF
    
    echo -e "${GREEN}✓ .env file created${NC}"
else
    echo -e "${YELLOW}⚠ .env file already exists, skipping creation${NC}"
fi

echo ""
echo "=================================================="
echo "Starting n8n..."
echo "=================================================="
echo ""

# Start Docker Compose
if docker compose version &> /dev/null 2>&1; then
    docker compose up -d
else
    docker-compose up -d
fi

echo ""
echo -e "${GREEN}✓ n8n is starting up...${NC}"
echo ""

# Wait for n8n to be ready
echo "Waiting for n8n to be ready..."
sleep 10

# Check if n8n is running
if docker ps | grep -q n8n; then
    echo -e "${GREEN}✓ n8n is running!${NC}"
    echo ""
    echo "=================================================="
    echo "Setup Complete!"
    echo "=================================================="
    echo ""
    echo "Access n8n at: http://localhost:5678"
    echo ""
    echo "Login credentials:"
    echo "  Username: $(grep N8N_USER .env | cut -d '=' -f2)"
    echo "  Password: (check your .env file)"
    echo ""
    echo "=================================================="
    echo "Next Steps:"
    echo "=================================================="
    echo ""
    echo "1. Set up SSL/HTTPS for your domain (required for WhatsApp webhooks)"
    echo "   - Use Cloudflare, nginx, or Traefik"
    echo ""
    echo "2. Import the WhatsApp workflow:"
    echo "   - Copy the webhook verification code"
    echo "   - Create a new workflow in n8n"
    echo "   - Add Webhook and Code nodes"
    echo ""
    echo "3. Configure WhatsApp webhook in Meta:"
    echo "   - Go to https://developers.facebook.com/"
    echo "   - Your webhook URL will be: https://$(grep N8N_HOST .env | cut -d '=' -f2)/webhook/whatsapp-webhook"
    echo "   - Verify token: $(grep WHATSAPP_VERIFY_TOKEN .env | cut -d '=' -f2)"
    echo ""
    echo "4. Test your integration!"
    echo ""
    echo "For detailed instructions, check n8n-whatsapp-setup-guide.md"
    echo ""
else
    echo -e "${RED}✗ Error: n8n failed to start${NC}"
    echo "Check logs with: docker logs n8n"
    exit 1
fi

echo ""
echo "View logs with: docker logs -f n8n"
echo "Stop n8n with: docker-compose down"
echo "=================================================="