import requests

# Replace with your personal access token
access_token = 'your_token_here'

# Replace with your room ID
room_id = 'your_room_id'

url = 'https://webexapis.com/v1/memberships'

headers = {
    'Authorization': 'Bearer {}'.format(access_token),
    'Content-Type': 'application/json'
}

params = {'roomId': room_id}

res = requests.get(url, headers=headers, params=params)
print(res.json())
