import requests

# Replace with your personal access token
access_token = 'your_token_here'

# Replace with your room ID
room_id = 'your_room_id'

# Replace with the email of the person to add
person_email = 'new-user@example.com'

url = 'https://webexapis.com/v1/memberships'

headers = {
    'Authorization': 'Bearer {}'.format(access_token),
    'Content-Type': 'application/json'
}

params = {'roomId': room_id, 'personEmail': person_email}

res = requests.post(url, headers=headers, json=params)
print(res.json())
