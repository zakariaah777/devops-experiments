# Di3 – Eigen Image Experiment 2 (SQL)

## Wat doet dit?
Flask web service met **SQLite database** waarmee je afbeeldingen kunt uploaden, diverse filters kunt toepassen, én **geschiedenis en statistieken** kunt bekijken van alle verwerkingen. De app draait in een Docker container en gebruikt Pillow voor image processing.

## Nieuwe features t.o.v. Di2
- ✅ **SQLite database** - Persistente opslag van alle verwerkingen
- ✅ **Geschiedenis pagina** - Zie alle verwerkte afbeeldingen (laatste 50)
- ✅ **Statistieken dashboard** - Totaal verwerkingen, gebruikte filters, verwerkte data
- ✅ **Filter populariteit** - Visuele grafiek van meest gebruikte filters
- ✅ **Docker volume** - Database blijft bewaard tussen container restarts
- ✅ **Navigatie menu** - Schakel tussen Upload en Geschiedenis

## Database Schema
```sql
CREATE TABLE image_history (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    filename TEXT NOT NULL,
    filter_type TEXT NOT NULL,
    file_size INTEGER,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

## Stap 1: Ga naar de directory
```bash
cd Docker/Di3_ImageExperimentSQL
```

## Stap 2: Installeer dependencies (optioneel voor lokaal testen)
```bash
pip3 install flask pillow
```

## Stap 3: Test de app lokaal (optioneel)
```bash
python3 image_app.py
```

Open browser: `http://0.0.0.0:8080`

Je ziet een paarse gradient interface met:
- **Upload pagina** - Upload formulier met 20+ filters
- **Geschiedenis link** - Navigatie naar statistieken pagina

Stop met `Ctrl+C`.

## Stap 4: Bouw en run de Docker container
```bash
bash image-app.sh
```

Dit script doet:
1. Maakt tempdir directories
2. Kopieert app files naar tempdir
3. Maakt een Dockerfile met Flask en Pillow
4. Bouwt de Docker container (imageappsql)
5. Runt de container met **persistent volume** (imagerunningsql)
6. Toont draaiende containers

Je ziet output met "Successfully built" en "Successfully tagged imageappsql".

## Stap 5: Test de app in Docker

### Upload Pagina
- Ga naar `http://localhost:8080`
- Upload een afbeelding en selecteer een filter
- Download de verwerkte afbeelding

### Geschiedenis Pagina
- Klik op **"Geschiedenis"** in het menu
- Bekijk de **statistieken dashboard**:
  - Totaal aantal verwerkingen
  - Totale hoeveelheid verwerkte data
  - Aantal gebruikte filters
- Zie de **populairste filters** met visuele bar chart
- Scroll naar beneden voor **volledige geschiedenis tabel** (laatste 50 items)

## Statistieken Features

### Dashboard
De geschiedenis pagina toont drie belangrijke metrics:
1. **Totaal Verwerkingen** - Aantal keer dat een afbeelding verwerkt is
2. **Totaal Verwerkt** - Totale grootte van alle verwerkte bestanden (in MB)
3. **Gebruikte Filters** - Aantal verschillende filters dat gebruikt is

### Filter Populariteit
Visuele bar chart toont:
- Top 10 meest gebruikte filters
- Aantal keer dat elk filter gebruikt is
- Percentage van totaal (via breedte van de bar)

### Geschiedenis Tabel
Toont voor elke verwerking:
- **ID** - Uniek verwerkings nummer
- **Bestandsnaam** - Originele bestandsnaam
- **Filter** - Toegepaste filter (met kleur badge)
- **Grootte** - Bestandsgrootte in KB
- **Tijdstip** - Wanneer verwerkt (datum + tijd)

## Stap 6: Database persistentie testen

**Stop de container:**
```bash
docker stop imagerunningsql
```

**Verwijder de container:**
```bash
docker rm imagerunningsql
```

**Start een nieuwe container (met zelfde volume):**
```bash
cd tempdir
docker run -t -d -p 8080:8080 -v imageapp-data:/home/imageapp --name imagerunningsql imageappsql
```

**Check de geschiedenis:**
- Ga naar `http://localhost:8080/history`
- Je ziet dat **alle oude verwerkingen nog steeds aanwezig zijn**!
- Dit komt door de Docker volume `imageapp-data`

## Stap 7: Verken de database (optioneel)

**Ga in de container:**
```bash
docker exec -it imagerunningsql /bin/bash
```

**Verken de database:**
```bash
cd /home/imageapp
ls -la image_history.db
```

**Query de database (als je sqlite3 hebt):**
```bash
# Installeer sqlite3 in container
apt-get update && apt-get install -y sqlite3

# Open database
sqlite3 image_history.db

# Voer queries uit
SELECT * FROM image_history ORDER BY timestamp DESC LIMIT 10;
SELECT filter_type, COUNT(*) FROM image_history GROUP BY filter_type;
.quit
```

**Exit de container:**
```bash
exit
```

## Stap 8: Stoppen en opruimen

**Stop de container:**
```bash
docker stop imagerunningsql
```

**Verwijder de container:**
```bash
docker rm imagerunningsql
```

**Bekijk alle containers:**
```bash
docker ps -a
```

**Verwijder het image (optioneel):**
```bash
docker rmi imageappsql
```

**Verwijder de Docker volume (verwijdert de database!):**
```bash
docker volume rm imageapp-data
```

**Ruim tempdir op:**
```bash
rm -rf tempdir
```

---

## Beschikbare Filters

Alle filters van Di2 zijn beschikbaar:

### Basis filters
- **Origineel** - Geen filter
- **Grijswaarden** - Zwart-wit conversie
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
- **Helderheid (+50%)** - Verhoogt helderheid
- **Contrast (+50%)** - Verhoogt contrast

### Transformaties
- **Roteer 90°/180°/270°** - Rotaties
- **Horizontaal spiegelen** - Flip left-right
- **Verticaal spiegelen** - Flip top-bottom
- **Thumbnail (200x200)** - Verkleint naar thumbnail

---

## Technische Details

### Technologie Stack
- **Flask** - Web framework
- **Pillow (PIL)** - Image processing
- **SQLite3** - Relationele database
- **Docker Volumes** - Persistente data opslag
- **Werkzeug** - Secure filename handling

### Database Informatie
- **Type**: SQLite3 (file-based)
- **Locatie**: `/home/imageapp/image_history.db`
- **Persistentie**: Docker volume `imageapp-data`
- **Auto-initialize**: Database wordt automatisch aangemaakt bij startup

### Beveiligingsfeatures
- Secure filename sanitization
- File extension validation
- Automatic file cleanup na processing
- SQL injection preventie (parameterized queries)
- Max file size limiting (16 MB)

### Poorten en Volumes
- **Flask app**: Poort 8080
- **Docker mapping**: localhost:8080 → container:8080
- **Docker volume**: `imageapp-data` → `/home/imageapp`

---

## Wat leer je?

### Database & Backend
- SQLite database integratie in Flask
- Database schema design
- SQL queries (INSERT, SELECT, GROUP BY)
- Persistente data opslag met Docker volumes
- Database initialization en migrations

### Frontend
- Multi-page web applicatie
- Navigation tussen paginas
- Data visualisatie (bar charts met CSS)
- Responsive statistics dashboard
- Template inheritance in Flask

### DevOps
- Docker volumes voor persistentie
- Container data management
- Database backup strategieën
- Stateful vs stateless containers

### Software Engineering
- CRUD operaties (Create, Read)
- MVC pattern in Flask
- Code reusability (templates, CSS)
- Feature extensibility (Di2 → Di3)

---

## Verschillen met Di2

| Feature | Di2 | Di3 |
|---------|-----|-----|
| Database | ❌ Geen | ✅ SQLite |
| Geschiedenis | ❌ Geen | ✅ Laatste 50 verwerkingen |
| Statistieken | ❌ Geen | ✅ Dashboard met metrics |
| Persistentie | ❌ Geen | ✅ Docker volume |
| Navigatie | ❌ Single page | ✅ Multi-page (Upload + Geschiedenis) |
| Filter analytics | ❌ Geen | ✅ Populariteit grafiek |
| Container naam | imagerunning | imagerunningsql |
| Image naam | imageapp | imageappsql |

---

## Troubleshooting

### Database is leeg na herstart
- Check of je de Docker volume gebruikt: `-v imageapp-data:/home/imageapp`
- Verwijder je misschien het volume per ongeluk?

### Geschiedenis pagina toont geen data
- Upload eerst wat afbeeldingen op de upload pagina
- Database wordt pas gevuld na eerste verwerking

### "Table already exists" error
- Dit is normaal als de database al bestaat
- De app checkt en maakt alleen nieuwe tables als ze niet bestaan

### Container naam conflict
```bash
# Stop en verwijder oude container
docker stop imagerunningsql
docker rm imagerunningsql
# Of gebruik andere naam in script
```

---

## Uitbreidingsideeën

Mogelijke uitbreidingen voor Di4:
- 👤 **User authentication** - Login systeem
- 🖼️ **Afbeelding opslag** - Sla verwerkte afbeeldingen op
- 🔍 **Zoekfunctie** - Zoek op bestandsnaam of filter
- 📊 **Geavanceerde analytics** - Grafieken met Chart.js
- 🗑️ **Delete functionaliteit** - Verwijder items uit geschiedenis
- 📅 **Datum filters** - Filter geschiedenis op datum
- 🎨 **Custom filters** - Gebruikers kunnen eigen filters maken
- 🐘 **PostgreSQL** - Upgrade naar production database
