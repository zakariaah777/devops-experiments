#!/usr/bin/env python3
import requests
import urllib.parse

key = "a507e815-0ca7-4b3f-ae2e-332d732f8d7a"
route_url = "https://graphhopper.com/api/1/route?"

def geocoding(location, key):
    while location == "":
        location = input("Voer de locatie opnieuw in: ")

    geocode_url = "https://graphhopper.com/api/1/geocode?"
    url = geocode_url + urllib.parse.urlencode({"q": location, "limit": "1", "key": key})

    replydata = requests.get(url)
    json_data = replydata.json()
    json_status = replydata.status_code

    if json_status == 200 and len(json_data["hits"]) != 0:
        lat = json_data["hits"][0]["point"]["lat"]
        lng = json_data["hits"][0]["point"]["lng"]
        name = json_data["hits"][0]["name"]
        value = json_data["hits"][0]["osm_value"]

        country = json_data["hits"][0].get("country", "")
        state = json_data["hits"][0].get("state", "")

        if state and country:
            new_loc = f"{name}, {state}, {country}"
        elif country:
            new_loc = f"{name}, {country}"
        else:
            new_loc = name

        print(f"Geocoding API URL for {new_loc} (Location Type: {value})")
        print(url)
    else:
        lat = "null"
        lng = "null"
        new_loc = location
        if json_status != 200:
            print(f"Geocode API status: {json_status}")
            print(f"Error message: {json_data.get('message', 'Unknown error')}")

    return json_status, lat, lng, new_loc

while True:
    print("\n+++++++++++++++++++++++++++++++++++++++++++++")
    print("Vehicle profiles available on Graphhopper:")
    print("+++++++++++++++++++++++++++++++++++++++++++++")
    print("car, bike, foot")
    print("+++++++++++++++++++++++++++++++++++++++++++++")

    profile = ["car", "bike", "foot"]
    vehicle = input("Enter a vehicle profile from the list above: ")

    if vehicle == "quit" or vehicle == "q":
        break
    elif vehicle not in profile:
        vehicle = "car"
        print("No valid vehicle profile was entered. Using the car profile.")

    loc1 = input("Starting Location: ")
    if loc1 == "quit" or loc1 == "q":
        break
    orig = geocoding(loc1, key)

    loc2 = input("Destination: ")
    if loc2 == "quit" or loc2 == "q":
        break
    dest = geocoding(loc2, key)

    print("=================================================")

    if orig[0] == 200 and dest[0] == 200:
        op = f"&point={orig[1]}%2C{orig[2]}"
        dp = f"&point={dest[1]}%2C{dest[2]}"
        paths_url = route_url + urllib.parse.urlencode({"key": key, "vehicle": vehicle}) + op + dp

        paths_response = requests.get(paths_url)
        paths_status = paths_response.status_code
        paths_data = paths_response.json()

        print(f"Routing API Status: {paths_status}")
        print(f"Routing API URL:\n{paths_url}")
        print("=================================================")
        print(f"Directions from {orig[3]} to {dest[3]} by {vehicle}")
        print("=================================================")

        if paths_status == 200:
            distance_m = paths_data["paths"][0]["distance"]
            km = distance_m / 1000
            miles = km / 1.61

            time_ms = paths_data["paths"][0]["time"]
            sec = int(time_ms / 1000 % 60)
            min = int(time_ms / 1000 / 60 % 60)
            hr = int(time_ms / 1000 / 60 / 60)

            print(f"Distance Traveled: {miles:.1f} miles / {km:.1f} km")
            print(f"Trip Duration: {hr:02d}:{min:02d}:{sec:02d}")
            print("=================================================")

            for instruction in paths_data["paths"][0]["instructions"]:
                text = instruction["text"]
                dist = instruction["distance"]
                print(f"{text} ( {dist/1000:.1f} km / {dist/1000/1.61:.1f} miles )")

            print("=================================================")
        else:
            print(f"Error message: {paths_data.get('message', 'Unknown error')}")
            print("*************************************************")
    else:
        print("Geocoding failed for one or both locations.")

print("Application terminated.")
