# 📅 Year Progress Threads Bot

An automated Threads bot that posts daily at exactly 09:15 GMT+0, visually indicating the percentage of the year passed using ASCII art.

## ✨ Example Post

```
20.00% of 2025 has passed.
[████················]
```

## 🚀 Getting Started

### Step 1: Prepare your Threads Account

- Create a dedicated Threads account for the bot.
- Sign up or log in at [Meta for Developers](https://developers.facebook.com/) to create a developer account.

### Step 2: Set Up a Meta App

1. Go to [Meta for Developers](https://developers.facebook.com/apps/)
2. Create a new app with the "Other" type
3. Add the "Threads API" product to your app
4. Configure the app settings:
   - Set up a valid Privacy Policy URL
   - Configure the OAuth redirect URL
   - Add test users for development

### Step 3: Obtain Threads API Credentials

You'll need the following credentials:
- `THREADS_USER_ID` - Your Threads user ID
- `THREADS_ACCESS_TOKEN` - A long-lived access token for the Threads API

To get a long-lived access token:
1. Generate a user access token with the `threads_manage` permission
2. Exchange it for a long-lived token using the [Access Token Tool](https://developers.facebook.com/tools/debug/accesstoken/)

### Step 4: Project Setup

```bash
mkdir year-progress-bot
cd year-progress-bot
python3 -m venv venv
source venv/bin/activate
pip install requests python-dotenv
```

### Step 5: Securely Store API Keys

Create a `.env` file in your project directory:

```
THREADS_USER_ID=your_threads_user_id
THREADS_ACCESS_TOKEN=your_threads_access_token
```

Replace placeholders with your actual credentials.

### 🧪 Test the Bot

Run the script manually to test:

```bash
python threads-bot.py
```

Verify the posts appear correctly on your Threads account.

## ⏰ Automate with GitHub Actions

This bot is configured to run automatically using GitHub Actions. The workflow is set up to:

1. Run daily at 09:15 GMT+0 (staggered 15 minutes after the X bot)
2. Use repository secrets for API credentials
3. Allow manual triggering for testing

### Setting Up GitHub Secrets

For the GitHub Action to work, you need to add your Threads API credentials as repository secrets:

1. Go to your GitHub repository
2. Navigate to Settings > Secrets and variables > Actions
3. Add the following secrets:
   - `THREADS_USER_ID` - Your Threads User ID
   - `THREADS_ACCESS_TOKEN` - Your Threads Access Token

### Manual Triggering

To manually trigger the workflow:

1. Go to your GitHub repository
2. Navigate to Actions > Threads-Bot Daily Post
3. Click "Run workflow"

## 📌 Verify Automation

After setting up the GitHub Action:

1. Check the Actions tab in your repository to see if the workflow runs successfully
2. Verify that posts are published to your Threads account at the scheduled time

## 🔍 Troubleshooting

- **Rate Limiting**: The Threads API has rate limits. If you hit them, the bot will log the error.
- **Token Expiration**: Access tokens expire. Make sure to refresh your long-lived token before it expires.
- **API Changes**: The Threads API is relatively new and may change. Check the [Meta for Developers documentation](https://developers.facebook.com/docs/threads) for updates.

## 🎉 Done!

Your bot is live and will automatically post the year's progress daily on Threads!
