import datetime
import os
import pathlib
import requests
import time
from dotenv import load_dotenv

# Try to load from .env file for local development
current_dir = pathlib.Path(__file__).parent.absolute()
env_path = current_dir.parent.parent / '.env'
if env_path.exists():
    load_dotenv(dotenv_path=env_path)

def year_progress_bar():
    """Generate year progress bar and message for Threads post."""
    today = datetime.datetime.utcnow()
    year_start = datetime.datetime(today.year, 1, 1)
    year_end = datetime.datetime(today.year + 1, 1, 1)
    
    total_days = (year_end - year_start).days
    days_passed = (today - year_start).days
    
    percent_passed = (days_passed / total_days) * 100
    
    bar_length = 20
    filled_length = int(bar_length * days_passed // total_days)
    bar = '█' * filled_length + '·' * (bar_length - filled_length)

    main_post = (
        f"{percent_passed:.2f}% of {today.year} has passed.\n"
        f"[{bar}]"
    )
    
    promo_post = (
        f"Keep track of your time ⏳\n"
        f"https://theyearprogress.app"
    )
    
    return main_post, promo_post

def create_threads_media_container(user_id, access_token, text, media_type="TEXT"):
    """Create a Threads media container."""
    url = f"https://graph.threads.net/v1.0/{user_id}/threads"
    
    params = {
        "media_type": media_type,
        "text": text,
        "access_token": access_token
    }
    
    print(f"Creating Threads media container with text: {text}")
    response = requests.post(url, params=params)
    
    if response.status_code != 200:
        print(f"Error creating Threads media container: {response.text}")
        raise Exception(f"Failed to create Threads media container: {response.text}")
    
    return response.json()["id"]

def publish_threads_media(user_id, access_token, creation_id):
    """Publish a Threads media container."""
    url = f"https://graph.threads.net/v1.0/{user_id}/threads_publish"
    
    params = {
        "creation_id": creation_id,
        "access_token": access_token
    }
    
    print(f"Publishing Threads media container with ID: {creation_id}")
    response = requests.post(url, params=params)
    
    if response.status_code != 200:
        print(f"Error publishing Threads media: {response.text}")
        raise Exception(f"Failed to publish Threads media: {response.text}")
    
    return response.json()["id"]

def post_to_threads(main_message, promo_message):
    """Post main message and promo reply to Threads."""
    try:
        user_id = os.getenv('THREADS_USER_ID')
        access_token = os.getenv('THREADS_ACCESS_TOKEN')
        
        print(f"Attempting to post to Threads with credentials:")
        print(f"THREADS_USER_ID: {user_id[:5] if user_id else 'Not set'}...")
        print(f"THREADS_ACCESS_TOKEN: {access_token[:5] if access_token else 'Not set'}...")
        
        # Create and publish main post
        main_container_id = create_threads_media_container(user_id, access_token, main_message)
        print(f"Main post container created with ID: {main_container_id}")
        
        # Wait for processing (recommended by Meta)
        print("Waiting 30 seconds for server processing...")
        time.sleep(30)
        
        # Publish main post
        main_post_id = publish_threads_media(user_id, access_token, main_container_id)
        print(f"Main post published successfully! Post ID: {main_post_id}")
        
        # Create and publish promo reply
        # For replies, we need to use the reply_control_web_id parameter
        # This is not directly supported in the API yet, so we'll just post a separate message
        promo_container_id = create_threads_media_container(user_id, access_token, promo_message)
        print(f"Promo post container created with ID: {promo_container_id}")
        
        # Wait for processing
        print("Waiting 30 seconds for server processing...")
        time.sleep(30)
        
        # Publish promo post
        promo_post_id = publish_threads_media(user_id, access_token, promo_container_id)
        print(f"Promo post published successfully! Post ID: {promo_post_id}")
        
        return main_post_id, promo_post_id
    except Exception as e:
        print(f"Error posting to Threads: {str(e)}")
        print(f"Error type: {type(e).__name__}")
        if hasattr(e, 'response') and hasattr(e.response, 'text'):
            print(f"Response text: {e.response.text}")
        raise

if __name__ == "__main__":
    main_message, promo_message = year_progress_bar()
    print(f"Generated main message: {main_message}")
    print(f"Generated promo message: {promo_message}")
    post_to_threads(main_message, promo_message)
