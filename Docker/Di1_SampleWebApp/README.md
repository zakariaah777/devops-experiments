# Di1 – Sample Web App in Docker Container

## Wat doet dit?
Flask web app die je IP-adres toont, gebouwd en gerund in een Docker container. Lab 6.2.7.

## Stap 1: Ga naar de directory
```bash
cd Docker/Di1_SampleWebApp
```

## Stap 2: Installeer Flask (als je het nog niet hebt)
```bash
pip3 install flask
```

## Stap 3: Test de app zonder Docker (optioneel)
```bash
python3 sample_app.py
```

Open browser: `http://0.0.0.0:8080`
Je ziet: "You are calling me from 127.0.0.1" op light steel blue achtergrond.

Stop met `Ctrl+C`.

## Stap 4: Bouw en run de Docker container
```bash
bash sample-app.sh
```

Dit script doet:
1. Maakt tempdir directories
2. Kopieert app files naar tempdir
3. Maakt een Dockerfile
4. Bouwt de Docker container (sampleapp)
5. Runt de container (samplerunning)
6. Toont draaiende containers

Je ziet output met "Successfully built" en "Successfully tagged sampleapp".

## Stap 5: Test de app in Docker

**In browser:**
- Ga naar `http://localhost:8080`
- Je ziet: "You are calling me from 172.17.0.1"

**Met curl:**
```bash
curl http://localhost:8080
```

## Stap 6: Verken de Docker container (optioneel)

**Ga in de container:**
```bash
docker exec -it samplerunning /bin/bash
```

Je bent nu in de container! Verken met `ls`, `ls /home/myapp`, etc.

**Exit de container:**
```bash
exit
```

## Stap 7: Stoppen en opruimen

**Stop de container:**
```bash
docker stop samplerunning
```

**Verwijder de container:**
```bash
docker rm samplerunning
```

**Bekijk alle containers:**
```bash
docker ps -a
```

**Herstart een gestopte container:**
```bash
docker start samplerunning
```

---

## Extra: Bash Script Test

Test het bash script (Part 2 van lab):
```bash
./user-input
```

Vul je naam in en druk Enter.

---

## Wat leer je?
- Bash scripting
- Flask web apps maken
- Docker containers bouwen en runnen
- Docker commands (build, run, stop, rm, exec, ps)
- Automatiseren met bash scripts
