import requests
import json

# Replace with your personal access token
access_token = 'your_token_here'

url = 'https://webexapis.com/v1/people'

headers = {
    'Authorization': 'Bearer {}'.format(access_token),
    'Content-Type': 'application/json'
}

params = {
    'email': 'user@example.com'  # Replace with actual email
}

res = requests.get(url, headers=headers, params=params)
print(json.dumps(res.json(), indent=4))

# Part 2: Get person details by ID (uncomment after getting person_id)
# person_id = 'previous_id_here'
# url = 'https://webexapis.com/v1/people/{}'.format(person_id)
# headers = {
#     'Authorization': 'Bearer {}'.format(access_token),
#     'Content-Type': 'application/json'
# }
# res = requests.get(url, headers=headers)
# print(json.dumps(res.json(), indent=4))
