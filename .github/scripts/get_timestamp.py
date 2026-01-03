"""
Script to get current timestamp for generation logging
Usage: python get_timestamp.py
Output: YYYY-MM-DD HH:mm:ss
"""
from datetime import datetime

if __name__ == "__main__":
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(timestamp)
