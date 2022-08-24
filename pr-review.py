import requests
import sys

from bs4 import BeautifulSoup

response = requests.get("https://bitcoincore.reviews")
if response.status_code == 200:
    html_text = response.text
    Soup = BeautifulSoup(html_text, "html.parser")
    
    result = Soup.find_all("a", class_="Home-posts-post-title")
    if len(result) > 1:

        print(result[0].attrs['href'][1:])

    