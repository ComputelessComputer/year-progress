import datetime
import tweepy
import os
from dotenv import load_dotenv
import pathlib


# Try to load from .env file for local development
current_dir = pathlib.Path(__file__).parent.absolute()
env_path = current_dir.parent.parent / '.env'
if env_path.exists():
    load_dotenv(dotenv_path=env_path)

def year_progress_bar():
    today = datetime.datetime.now(datetime.timezone.utc)
    year_start = datetime.datetime(today.year, 1, 1, tzinfo=datetime.timezone.utc)
    year_end = datetime.datetime(today.year + 1, 1, 1, tzinfo=datetime.timezone.utc)

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
    try:
        print(f"Attempting to tweet with credentials:")
        print(f"API_KEY: {os.getenv('API_KEY')[:5]}...")
        print(f"API_SECRET: {os.getenv('API_SECRET')[:5]}...")
        print(f"ACCESS_TOKEN: {os.getenv('ACCESS_TOKEN')[:5]}...")
        print(f"ACCESS_TOKEN_SECRET: {os.getenv('ACCESS_TOKEN_SECRET')[:5]}...")
        
        client = tweepy.Client(
            consumer_key=os.getenv('API_KEY'),
            consumer_secret=os.getenv('API_SECRET'),
            access_token=os.getenv('ACCESS_TOKEN'),
            access_token_secret=os.getenv('ACCESS_TOKEN_SECRET')
        )

        response = client.create_tweet(text=message)
        print(f"Tweet posted successfully! Tweet ID: {response.data['id']}")
        return response
    except Exception as e:
        print(f"Error posting tweet: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        if hasattr(e, 'response') and hasattr(e.response, 'text'):
            print(f"Response text: {e.response.text}")
        raise

if __name__ == "__main__":
    message = year_progress_bar()
    print(f"Generated message: {message}")
    tweet(message)