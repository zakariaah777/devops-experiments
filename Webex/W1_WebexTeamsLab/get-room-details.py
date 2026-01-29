import requests

# Replace with your personal access token
access_token = 'your_token_here'

# Replace with the room ID from create-rooms.py
room_id = 'your_room_id'

url = 'https://webexapis.com/v1/rooms/{}/meetingInfo'.format(room_id)

headers = {
    'Authorization': 'Bearer {}'.format(access_token),
    'Content-Type': 'application/json'
}

res = requests.get(url, headers=headers)
print(res.json())
