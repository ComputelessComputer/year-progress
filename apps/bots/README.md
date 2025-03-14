# 📅 Year Progress X Bot

An automated X (Twitter) bot that posts daily at exactly 00:00 GMT+0, visually indicating the percentage of the year passed using ASCII art.

## ✨ Example Tweet

```
Year Progress: [███████·················] 20.00%
▕░░░░░░░░░░░░░░░░░░░▏ Day 73 of 365
```

## 🚀 Getting Started

### Step 1: Prepare your X (Twitter) Account

- Create a dedicated X account for the bot.
- Sign up or log in at developer.x.com to create a developer account.

### Step 2: Obtain X API Credentials

Create an App in the developer portal and generate the following:

- API_KEY
- API_SECRET
- ACCESS_TOKEN
- ACCESS_TOKEN_SECRET

### Step 3: Project Setup

```bash
mkdir year-progress-bot
cd year-progress-bot
python3 -m venv venv
source venv/bin/activate
pip install tweepy python-dotenv
```

### Step 4: Create Bot Script

Save this as year_progress_bot.py:

```python
import datetime
import tweepy
import os
from dotenv import load_dotenv

load_dotenv()

def year_progress_bar():
    today = datetime.datetime.utcnow()
    year_start = datetime.datetime(today.year, 1, 1)
    year_end = datetime.datetime(today.year + 1, 1, 1)

    days_passed = (today - year_start).days + 1
    total_days = (year_end - year_start).days
    percent_passed = (today - year_start).total_seconds() / (year_end - year_start).total_seconds() * 100

    bar_length = 20
    filled_length = int(bar_length * percent_passed // 100)

    bar = '█' * filled_length + '·' * (bar_length - filled_length)

    post = (
        f"Year Progress: [{bar}] {percent_passed:.2f}%\n"
        f"▕{'░' * bar_length}▏ Day {days_passed} of {total_days}"
    )
    return post

def tweet(message):
    client = tweepy.Client(
        consumer_key=os.getenv('API_KEY'),
        consumer_secret=os.getenv('API_SECRET'),
        access_token=os.getenv('ACCESS_TOKEN'),
        access_token_secret=os.getenv('ACCESS_TOKEN_SECRET')
    )

    client.create_tweet(text=message)

if __name__ == "__main__":
    message = year_progress_bar()
    tweet(message)
```

### Step 5: Securely Store API Keys

Create a .env file in your project directory:

```
API_KEY=your_api_key
API_SECRET=your_api_secret
ACCESS_TOKEN=your_access_token
ACCESS_TOKEN_SECRET=your_access_token_secret
```

Replace placeholders with your actual credentials.

### 🧪 Test the Bot

Run the script manually to test:

```bash
python bot.py
```

Verify the tweet posted correctly.

## ⏰ Automate with GitHub Actions

This bot is configured to run automatically using GitHub Actions. The workflow is set up to:

1. Run daily at midnight (00:00 GMT+0)
2. Use repository secrets for API credentials
3. Allow manual triggering for testing

### Setting Up GitHub Secrets

For the GitHub Action to work, you need to add your X API credentials as repository secrets:

1. Go to your GitHub repository
2. Navigate to Settings > Secrets and variables > Actions
3. Add the following secrets:
   - `API_KEY` - Your X API Key
   - `API_SECRET` - Your X API Secret
   - `ACCESS_TOKEN` - Your X Access Token
   - `ACCESS_TOKEN_SECRET` - Your X Access Token Secret

### Manual Triggering

To manually trigger the workflow:

1. Go to your GitHub repository
2. Navigate to Actions > X-Bot Daily Post
3. Click "Run workflow"

## 📌 Verify Automation

After setting up the GitHub Action:

1. Check the Actions tab in your repository to see if the workflow runs successfully
2. Verify that tweets are posted to your X account at the scheduled time

##🎉 Done!

Your bot is live and will automatically post the year's progress daily. Happy tweeting!
