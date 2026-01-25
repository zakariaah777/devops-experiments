# Pf1 – Jenkins CI/CD Sample App

## Wat doet dit?
Simpele Flask app die je IP-adres toont. Gebruikt voor Jenkins CI/CD pipeline lab (Lab 6.3.6).

## Uitvoeren

```bash
cd Flask/Pf1_JenkinsPipeline

# Installeer Flask
pip3 install flask

# Run de app
python3 sample_app.py
```

**Open browser:** `http://localhost:5050`

**Wat je ziet:** "You are calling me from 127.0.0.1" op light steel blue achtergrond

**Stop:** `Ctrl+C`

## Met Docker (optioneel)

```bash
bash ./sample-app.sh
```

**Stop:**
```bash
docker stop samplerunning
docker rm samplerunning
```

## Doel
Deze app is voor het Jenkins CI/CD lab waar je leert automatisch code te builden, testen en deployen.
