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
    today = datetime.datetime.utcnow()
    year_start = datetime.datetime(today.year, 1, 1)
    year_end = datetime.datetime(today.year + 1, 1, 1)
    
    total_days = (year_end - year_start).days
    days_passed = (today - year_start).days
    
    percent_passed = (days_passed / total_days) * 100
    
    bar_length = 20
    filled_length = int(bar_length * days_passed // total_days)
    bar = '█' * filled_length + '·' * (bar_length - filled_length)

    main_tweet = (
        f"{percent_passed:.2f}% of {today.year} has passed.\n"
        f"[{bar}]"
    )
    
    promo_tweet = (
        f"Keep track of your time ⏳\n"
        f"https://theyearprogress.app"
    )
    
    return main_tweet, promo_tweet

def tweet(main_message, promo_message):
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

        # Post the main tweet
        main_response = client.create_tweet(text=main_message)
        print(f"Main tweet posted successfully! Tweet ID: {main_response.data['id']}")
        
        # Post the promo reply as a thread
        promo_response = client.create_tweet(
            text=promo_message,
            in_reply_to_tweet_id=main_response.data['id']
        )
        print(f"Promo tweet posted successfully! Tweet ID: {promo_response.data['id']}")
        
        return main_response, promo_response
    except Exception as e:
        print(f"Error posting tweet: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        if hasattr(e, 'response') and hasattr(e.response, 'text'):
            print(f"Response text: {e.response.text}")
        raise

if __name__ == "__main__":
    main_message, promo_message = year_progress_bar()
    print(f"Generated main message: {main_message}")
    print(f"Generated promo message: {promo_message}")
    tweet(main_message, promo_message)