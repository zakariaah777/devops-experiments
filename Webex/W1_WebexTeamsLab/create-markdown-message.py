import requests

# Replace with your personal access token
access_token = 'your_token_here'

# Replace with your room ID
room_id = 'your_room_id'

# Message with Markdown formatting
message = 'Hello **DevNet Associates**!!'

url = 'https://webexapis.com/v1/messages'

headers = {
    'Authorization': 'Bearer {}'.format(access_token),
    'Content-Type': 'application/json'
}

params = {'roomId': room_id, 'markdown': message}

res = requests.post(url, headers=headers, json=params)
print(res.json())
