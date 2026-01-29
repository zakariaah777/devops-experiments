#!/usr/bin/env python3
import requests
import time

# API endpoints
ISS_LOCATION_URL = "http://api.open-notify.org/iss-now.json"
ASTROS_URL = "http://api.open-notify.org/astros.json"

def haal_iss_locatie():
    """Haalt de huidige locatie van het ISS op"""
    try:
        response = requests.get(ISS_LOCATION_URL)
        data = response.json()

        if response.status_code == 200:
            latitude = data["iss_position"]["latitude"]
            longitude = data["iss_position"]["longitude"]
            timestamp = data["timestamp"]

            print("\n" + "="*50)
            print("🛰️  ISS HUIDIGE POSITIE")
            print("="*50)
            print(f"Latitude:  {latitude}°")
            print(f"Longitude: {longitude}°")
            print(f"Timestamp: {timestamp}")
            print(f"Google Maps: https://maps.google.com/?q={latitude},{longitude}")
            print("="*50)
        else:
            print(f"❌ Fout: Status code {response.status_code}")
    except Exception as e:
        print(f"❌ Fout bij ophalen ISS locatie: {e}")

def haal_astronauten():
    """Haalt informatie op over astronauten in de ruimte"""
    try:
        response = requests.get(ASTROS_URL)
        data = response.json()

        if response.status_code == 200:
            aantal = data["number"]
            mensen = data["people"]

            print("\n" + "="*50)
            print("👨‍🚀 MENSEN IN DE RUIMTE")
            print("="*50)
            print(f"Totaal aantal: {aantal}")
            print("\nNamen en locaties:")
            print("-"*50)

            for persoon in mensen:
                naam = persoon["name"]
                craft = persoon["craft"]
                print(f"  • {naam} ({craft})")

            print("="*50)
        else:
            print(f"❌ Fout: Status code {response.status_code}")
    except Exception as e:
        print(f"❌ Fout bij ophalen astronauten: {e}")

def toon_alles():
    """Toont zowel ISS locatie als astronauten"""
    haal_iss_locatie()
    haal_astronauten()

def live_tracking():
    """Volg het ISS in real-time (update elke 5 seconden)"""
    print("\n🔄 Live tracking gestart... (Druk Ctrl+C om te stoppen)")
    try:
        while True:
            haal_iss_locatie()
            print("\n⏳ Wacht 5 seconden...")
            time.sleep(5)
    except KeyboardInterrupt:
        print("\n\n✅ Live tracking gestopt.")

def toon_menu():
    """Toont het hoofdmenu"""
    print("\n" + "="*50)
    print("🚀 ISS TRACKER - INTERNATIONAL SPACE STATION")
    print("="*50)
    print("1. Toon ISS huidige locatie")
    print("2. Toon astronauten in de ruimte")
    print("3. Toon beide")
    print("4. Live tracking (update elke 5 sec)")
    print("q. Stop programma")
    print("="*50)

def main():
    """Hoofdfunctie"""
    while True:
        toon_menu()
        keuze = input("\nKies een optie: ").strip().lower()

        if keuze == "1":
            haal_iss_locatie()
        elif keuze == "2":
            haal_astronauten()
        elif keuze == "3":
            toon_alles()
        elif keuze == "4":
            live_tracking()
        elif keuze == "q":
            print("\n👋 Programma gestopt. Tot ziens!")
            break
        else:
            print("\n❌ Ongeldige keuze. Probeer opnieuw.")

if __name__ == "__main__":
    main()
