# Pf3 – URL Shortener Microservice

## Wat doet dit?
Een microservice die lange URLs verkort naar korte links (zoals bit.ly).

## Hoe run je dit?

```bash
cd Flask/Pf3_URLShortener
python3 url-shortener.py
```

## Hoe test je dit?

**Browser:**
- Ga naar `http://0.0.0.0:5000`
- Vul een lange URL in
- Klik "Verkort URL"
- Gebruik de korte URL om te redirecten

**Met curl:**
```bash
# Verkort een URL
curl -X POST -F 'url=https://www.google.com' http://0.0.0.0:5000/shorten

# Test de korte URL (vervang ABC123 met jouw code)
curl -L http://0.0.0.0:5000/ABC123

# Bekijk stats
curl http://0.0.0.0:5000/stats/ABC123
```

## Wat zie je?
- Je krijgt een korte URL terug (bijv. `http://0.0.0.0:5000/aB3xY2`)
- Als je de korte URL bezoekt, word je doorgestuurd naar de originele URL
- Elke click wordt geteld
- Stats tonen hoeveel keer de link is gebruikt

## Stoppen
```bash
# Druk Ctrl+C in de terminal waar de server draait
```
