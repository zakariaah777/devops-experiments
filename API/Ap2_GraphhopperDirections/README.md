# Ap2 – Graphhopper Directions API

## Hoe werkt het: 

Comment ça marche après 💡
Le programme va vous demander :

Vehicle profile : tapez car, bike, ou foot
Starting Location : tapez une ville (ex: "Brussels")
Destination : tapez une autre ville (ex: "Paris")
Il affichera la distance et les directions !
Pour quitter : tapez q

## Context
Dit experiment maakt deel uit van het vak **DevOps** en is gebaseerd op
**Lab 4.9.2 – Integrate a REST API in a Python Application** uit de NetAcad cursus.

## Doel
Een Python-applicatie bouwen die:
- Gebruikersinvoer vraagt voor startlocatie en bestemming
- Coördinaten ophaalt via de Graphhopper Geocoding API
- Route-informatie ophaalt via de Graphhopper Routing API
- Afstand, reistijd en stapsgewijze instructies toont

## Hoe het werkt
1. **Geocoding API**: Zet plaatsnamen om naar latitude/longitude
2. **Routing API**: Berekent route tussen twee coördinaten
3. **Output**: Toont afstand (km/miles), duur, en turn-by-turn navigatie

## Gebruikte technologieën
- Python 3
- `requests` module voor HTTP calls
- `urllib.parse` voor URL encoding
- Graphhopper REST API (Geocoding + Routing)

## Vereisten
```bash
pip3 install requests
```

## Gebruik
```bash
python3 graphhopper_directions.py
```

Kies een voertuigprofiel (car/bike/foot), voer start en bestemming in.
Typ `q` om te stoppen.

## API Key
Je hebt een gratis Graphhopper API key nodig:
https://www.graphhopper.com/ → Sign Up → API Keys
