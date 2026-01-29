# Pf3 – URL Shortener Microservice

## Wat doet dit?
Verkort lange URLs naar korte links (zoals bit.ly). Eigen microservice experiment.

## Stap 1: Ga naar de directory
```bash
cd Flask/Pf3_URLShortener
```

## Stap 2: Installeer Flask (als je het nog niet hebt)
```bash
pip3 install flask
```

## Stap 3: Start de app
```bash
python3 url-shortener.py
```

Je ziet:
```
* Running on http://0.0.0.0:5000
* Debug mode: on
```

## Stap 4: Test de app

### Optie A: Browser
1. Ga naar `http://0.0.0.0:5000`
2. Vul een lange URL in (bijv. `https://www.google.com/search?q=test`)
3. Klik "Verkort URL"
4. Je krijgt een korte URL zoals: `http://0.0.0.0:5000/aB3xY2`
5. Klik op de korte URL om te testen
6. Je wordt doorgestuurd naar de originele URL!

### Optie B: Curl (open nieuwe terminal)
```bash
# Terminal 1: server draait
# Terminal 2: test met curl

# Verkort een URL
curl -X POST -F 'url=https://www.google.com' http://0.0.0.0:5000/shorten

# Je krijgt bijv: Short URL: http://0.0.0.0:5000/eYXOOx

# Test de redirect
curl -L http://0.0.0.0:5000/eYXOOx

# Bekijk stats (hoeveel clicks)
curl http://0.0.0.0:5000/stats/eYXOOx
```

## Stap 5: Stoppen
Druk `Ctrl+C` in de terminal waar de app draait.

---

## Wat doet het?
- Verkort lange URLs naar 6-karakter codes
- Slaat alles op in SQLite database (urls.db)
- Telt hoeveel keer elke link geklikt wordt
- Toont statistieken per link
