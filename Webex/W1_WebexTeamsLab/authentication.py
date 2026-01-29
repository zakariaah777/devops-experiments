import requests
import json

# Replace with your personal access token from https://developer.webex.com
access_token = 'your_token_here'

url = 'https://webexapis.com/v1/people/me'

headers = {
    'Authorization': 'Bearer {}'.format(access_token)
}

res = requests.get(url, headers=headers)
print(json.dumps(res.json(), indent=4))
