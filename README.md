# spachtelprofi-whatsapp-service - n8n WhatsApp Integration - Quick Setup

This package contains everything you need to set up n8n with WhatsApp webhook integration.

## 📦 Files Included

- `n8n-whatsapp-setup-guide.md` - Complete setup guide with detailed instructions
- `docker-compose.yml` - Production-ready Docker Compose configuration
- `.env.example` - Environment variables template
- `start-n8n.sh` - Quick start script for automated setup
- `webhook-verification.js` - Code for n8n webhook verification node
- `send-message-examples.js` - Examples for sending all types of WhatsApp messages
- `whatsapp-workflow.json` - Ready-to-import n8n workflow

## 🚀 Quick Start (5 minutes)

### Option 1: Automated Setup (Recommended)

```bash
# 1. Run the setup script
chmod +x start-n8n.sh
./start-n8n.sh

# 2. Access n8n at http://localhost:5678
# 3. Follow the on-screen instructions
```

### Option 2: Manual Setup

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Edit .env with your details
nano .env

# 3. Start n8n
docker-compose up -d

# 4. Access n8n at http://localhost:5678
```

## 📋 Prerequisites

- Docker & Docker Compose installed
- A domain name with HTTPS (for WhatsApp webhooks)
- Meta Business Account
- WhatsApp Business Account

## 🔧 Configuration Steps

### 1. Get WhatsApp API Credentials

1. Go to [Meta for Developers](https://developers.facebook.com/)
2. Create a new app (Business type)
3. Add WhatsApp product
4. Get your credentials:
   - Phone Number ID
   - Access Token
   - Create a Verify Token (any secret string)

### 2. Configure n8n

Edit your `.env` file:

```env
N8N_HOST=your-domain.com
WHATSAPP_PHONE_NUMBER_ID=your_phone_number_id
WHATSAPP_ACCESS_TOKEN=your_access_token
WHATSAPP_VERIFY_TOKEN=mySecretToken123
```

### 3. Import Workflow

1. Open n8n at http://localhost:5678
2. Click "Import from File"
3. Select `whatsapp-workflow.json`
4. Update the verify token in the "Parse Webhook" node if needed

### 4. Get Webhook URL

1. Execute the workflow once
2. Click on "WhatsApp Webhook" node
3. Copy the Production URL (e.g., `https://your-domain.com/webhook/whatsapp-webhook`)

### 5. Configure Meta Webhook

1. Go to WhatsApp API Setup in Meta
2. Click "Configure Webhooks"
3. Enter:
   - **Callback URL**: Your n8n webhook URL
   - **Verify Token**: Same as in your .env file
4. Subscribe to: `messages`

### 6. Test

Send a message to your WhatsApp Business number and check n8n executions!

## 📚 Common Use Cases

### Auto-Reply Bot

The included workflow automatically replies to incoming messages.

### Customer Support

Modify the workflow to:

- Route to different teams
- Store messages in a database
- Send notifications to Slack

### Notifications

Send automated WhatsApp messages:

- Order confirmations
- Appointment reminders
- Delivery updates

## 🔐 Security Best Practices

1. **Use HTTPS** - Required for WhatsApp webhooks
2. **Secure credentials** - Store tokens in environment variables
3. **Enable Basic Auth** - Protect n8n interface
4. **Firewall rules** - Restrict access to n8n ports
5. **Regular backups** - Backup workflows and data

## 📖 Message Types Supported

- ✅ Text messages
- ✅ Images
- ✅ Documents (PDF, DOCX, etc.)
- ✅ Audio
- ✅ Video
- ✅ Location
- ✅ Interactive buttons
- ✅ List messages
- ✅ Templates
- ✅ Reactions

See `send-message-examples.js` for code samples.

## 🐛 Troubleshooting

### Webhook not verified

- Check verify token matches in both Meta and n8n
- Ensure n8n is accessible via HTTPS
- Check n8n logs: `docker logs n8n`

### Messages not received

- Verify webhook subscription in Meta
- Check n8n workflow is active
- Look for errors in Meta webhook logs

### Can't send messages

- Verify access token is valid
- Check phone number ID is correct
- Ensure recipient has opted in

## 📞 Support

For detailed documentation, see `n8n-whatsapp-setup-guide.md`

## 🔗 Useful Links

- [n8n Documentation](https://docs.n8n.io/)
- [WhatsApp Business API](https://developers.facebook.com/docs/whatsapp)
- [Meta for Developers](https://developers.facebook.com/)

## 📝 Notes

- Test numbers work for development
- Production requires approved WhatsApp Business Account
- Template messages needed outside 24-hour window
- Rate limits apply to API calls

---

**Need help?** Check the full guide in `n8n-whatsapp-setup-guide.md`
