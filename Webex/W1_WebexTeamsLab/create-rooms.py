import requests

# Replace with your personal access token
access_token = 'your_token_here'

url = 'https://webexapis.com/v1/rooms'

headers = {
    'Authorization': 'Bearer {}'.format(access_token),
    'Content-Type': 'application/json'
}

params = {'title': 'DevNet Associate Training!'}

res = requests.post(url, headers=headers, json=params)
print(res.json())

# Save the room 'id' from the response for use in other scripts!
