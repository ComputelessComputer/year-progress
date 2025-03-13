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

## ⏰ Automate with Cron

Open your crontab:

```
crontab -e
```

Add the cron job (adjust paths accordingly):

```
0 0 \* \* \* cd /path/to/year-progress-bot && /path/to/year-progress-bot/venv/bin/python bot.py
```

## 📌 Verify Automation

Ensure the bot posts correctly at midnight (GMT+0). Check cron logs if troubleshooting is needed:

```bash
grep CRON /var/log/syslog
```

##🎉 Done!

Your bot is live and will automatically post the year’s progress daily. Happy tweeting!
