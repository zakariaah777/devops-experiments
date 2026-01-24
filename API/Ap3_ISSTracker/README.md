# Ap3 – ISS Tracker

## Wat doet dit?
Deze Python-applicatie volgt het **International Space Station (ISS)** in real-time. Het toont de huidige GPS-locatie van het ISS en wie er momenteel in de ruimte zijn.

## Vereisten
```bash
pip3 install requests
```

## Uitvoeren
```bash
cd API/Ap3_ISSTracker
python3 iss_tracker.py
```

## Gebruik
Kies een optie uit het menu:
- **1** - Toon ISS huidige locatie (GPS coördinaten + Google Maps link)
- **2** - Toon alle astronauten die nu in de ruimte zijn
- **3** - Toon beide
- **4** - Live tracking (update elke 5 seconden)
- **q** - Stop programma

## API
Gebruikt de gratis **Open Notify API**:
- http://api.open-notify.org/iss-now.json (ISS locatie)
- http://api.open-notify.org/astros.json (Astronauten)

Geen API key nodig! ✅
