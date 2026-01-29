# W1 - Webex Teams Lab (Lab 8.6.7)

## Doel
Python scripts gebruiken om de Webex Teams API te beheren:
- Authenticatie
- People beheren
- Rooms beheren
- Memberships beheren
- Messages versturen

## Stappen

### Stap 1: Access Token ophalen
1. Ga naar https://developer.webex.com
2. Log in of maak een account aan
3. Klik op **Documentation** → **Getting Started**
4. Kopieer je **Personal Access Token**

### Stap 2: Scripts uitvoeren (in volgorde)

| Script | Beschrijving |
|--------|--------------|
| `authentication.py` | Test je access token |
| `list-people.py` | Zoek een gebruiker op email |
| `list-rooms.py` | Toon al je rooms |
| `create-rooms.py` | Maak een nieuwe room |
| `get-room-details.py` | Haal room meeting info op |
| `list-memberships.py` | Toon leden van een room |
| `create-membership.py` | Voeg iemand toe aan een room |
| `create-markdown-message.py` | Stuur een bericht naar een room |

### Uitvoeren
```bash
cd Webex/W1_WebexTeamsLab
python3 authentication.py
```

## Let op!
- Je access token is **12 uur** geldig
- Bewaar je **room_id** na het aanmaken van een room
- Vervang alle `your_token_here` en `your_room_id` met echte waarden
