# Di2 – Eigen Image Experiment (Web Service)

## Wat doet dit?
Flask web service waarmee je afbeeldingen kunt uploaden en diverse filters en transformaties kunt toepassen. De app draait in een Docker container en gebruikt de Pillow library voor image processing.

## Stap 1: Ga naar de directory
```bash
cd Docker/Di2_ImageExperiment
```

## Stap 2: Installeer Flask en Pillow (als je het nog niet hebt)
```bash
pip3 install flask pillow
```

## Stap 3: Test de app zonder Docker (optioneel)
```bash
python3 image_app.py
```

Open browser: `http://0.0.0.0:8080`

Je ziet een paarse gradient interface met:
- Upload formulier voor afbeeldingen
- Dropdown menu met 20+ filters en transformaties
- Informatie over ondersteunde formaten

**Test de functionaliteit:**
1. Kies een afbeelding (PNG, JPG, GIF, etc.)
2. Selecteer een filter (bijv. "Grijswaarden" of "Sepia")
3. Klik op "Verwerk afbeelding"
4. De verwerkte afbeelding wordt automatisch gedownload

Stop met `Ctrl+C`.

## Stap 4: Bouw en run de Docker container
```bash
bash image-app.sh
```

Dit script doet:
1. Maakt tempdir directories (inclusief uploads folder)
2. Kopieert app files naar tempdir
3. Maakt een Dockerfile met Flask en Pillow
4. Bouwt de Docker container (imageapp)
5. Runt de container (imagerunning)
6. Toont draaiende containers

Je ziet output met "Successfully built" en "Successfully tagged imageapp".

## Stap 5: Test de app in Docker

**In browser:**
- Ga naar `http://localhost:8080`
- Upload een afbeelding en test verschillende filters

**Beschikbare filters:**

### Basis filters
- **Origineel** - Geen filter toegepast
- **Grijswaarden** - Converteert naar zwart-wit
- **Sepia** - Vintage bruine tint

### Effecten
- **Vervagen** - Blur effect
- **Verscherpen** - Sharpen details
- **Glad maken** - Smooth effect
- **Reliëf** - Emboss effect
- **Contour** - Toont contouren
- **Detail verbeteren** - Detail enhancement
- **Randen versterken** - Edge enhancement

### Aanpassingen
- **Helderheid (+50%)** - Maakt afbeelding lichter
- **Contrast (+50%)** - Verhoogt contrast

### Transformaties
- **Roteer 90°/180°/270°** - Rotaties
- **Horizontaal spiegelen** - Flip left-right
- **Verticaal spiegelen** - Flip top-bottom
- **Thumbnail (200x200)** - Verkleint naar thumbnail

## Stap 6: Verken de Docker container (optioneel)

**Ga in de container:**
```bash
docker exec -it imagerunning /bin/bash
```

Je bent nu in de container! Verken met:
```bash
ls /home/imageapp
ls /home/imageapp/templates
ls /home/imageapp/static
```

**Exit de container:**
```bash
exit
```

## Stap 7: Stoppen en opruimen

**Stop de container:**
```bash
docker stop imagerunning
```

**Verwijder de container:**
```bash
docker rm imagerunning
```

**Bekijk alle containers:**
```bash
docker ps -a
```

**Herstart een gestopte container:**
```bash
docker start imagerunning
```

**Verwijder het image (optioneel):**
```bash
docker rmi imageapp
```

**Ruim tempdir op:**
```bash
rm -rf tempdir
```

---

## Extra: Direct met Docker commands

Als je de container handmatig wilt bouwen en runnen:

**Bouw de container:**
```bash
docker build -t imageapp .
```

**Run de container:**
```bash
docker run -d -p 8080:8080 --name imagerunning imageapp
```

**Bekijk logs:**
```bash
docker logs imagerunning
```

---

## Technische details

### Gebruikte libraries:
- **Flask** - Web framework
- **Pillow (PIL)** - Image processing library
- **Werkzeug** - Secure filename handling

### Bestandslimieten:
- Max upload size: 16 MB
- Ondersteunde formaten: PNG, JPG, JPEG, GIF, BMP, WEBP

### Beveiligingsfeatures:
- Secure filename sanitization
- File extension validation
- Automatic file cleanup na processing
- Geen permanente opslag van uploads

### Poorten:
- Flask app draait op poort 8080
- Docker mapped naar localhost:8080

---

## Wat leer je?
- Flask web services bouwen
- Image processing met Pillow
- File uploads afhandelen in Flask
- Docker containers met Python dependencies
- Bash scripting voor Docker automation
- Security best practices (file validation, cleanup)
- RESTful web service design
- Docker commands en container management
