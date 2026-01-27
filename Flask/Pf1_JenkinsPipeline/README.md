# Pf1 – Jenkins CI/CD Sample App

## Wat doet dit?
Flask app die je IP-adres toont. Voor Jenkins CI/CD pipeline lab.

## Stap 1: Ga naar de directory
```bash
cd Flask/Pf1_JenkinsPipeline
```

## Stap 2: Installeer Flask (als je het nog niet hebt)
```bash
pip3 install flask
```

## Stap 3: Start de app
```bash
python3 sample_app.py
```

Je ziet:
```
* Running on http://0.0.0.0:5050
```

## Stap 4: Test de app

**In browser:**
- Ga naar `http://0.0.0.0:5050`
- Je ziet: "You are calling me from 127.0.0.1"

**Of met curl (nieuwe terminal):**
```bash
curl http://0.0.0.0:5050
```

## Stap 5: Stoppen
Druk `Ctrl+C` in de terminal waar de app draait.

---

## Met Docker (optioneel)

**Start:**
```bash
bash ./sample-app.sh
```

**Stop:**
```bash
docker stop samplerunning
docker rm samplerunning
```
