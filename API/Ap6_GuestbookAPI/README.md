# Ap6 – Gastenboek REST API

## Wat doet dit?
Een **REST API met HTML interface** voor een gastenboek. Je kunt het op **2 manieren** gebruiken:
1. **Browser** - HTML formulier om berichten toe te voegen en te bekijken
2. **curl** - REST API endpoints voor programmatisch gebruik

## Vereisten
```bash
pip3 install flask
```

## Uitvoeren
```bash
cd API/Ap6_GuestbookAPI
python3 app.py
```

---

## Gebruik Methode 1: Browser (HTML Forms)

Open je browser en ga naar: **http://localhost:5000**

**Wat je kunt doen:**
- ✅ Vul het formulier in (naam + bericht)
- ✅ Klik op "Bericht Toevoegen"
- ✅ Zie direct alle gastenboek entries
- ✅ Nieuwste berichten staan bovenaan

**Simpel en visueel!**

---

## Gebruik Methode 2: REST API (curl)

### 1. Alle entries ophalen (GET)
```bash
curl http://localhost:5000/api/entries
```

### 2. Specifieke entry ophalen (GET)
```bash
curl http://localhost:5000/api/entries/1
```

### 3. Nieuwe entry toevoegen (POST)
```bash
curl -X POST http://localhost:5000/api/entries \
  -H "Content-Type: application/json" \
  -d '{
    "naam": "Charlie",
    "bericht": "Dit is een test via curl!"
  }'
```

**Simpeler (één regel):**
```bash
curl -X POST http://localhost:5000/api/entries -H "Content-Type: application/json" -d '{"naam":"David","bericht":"REST API werkt perfect!"}'
```

### 4. Entry verwijderen (DELETE)
```bash
curl -X DELETE http://localhost:5000/api/entries/1
```

### 5. Statistieken ophalen (GET)
```bash
curl http://localhost:5000/api/stats
```

---

## Testen - Volledige Workflow

**Terminal 1:** Start de API
```bash
python3 app.py
```

**Terminal 2:** Test met curl
```bash
# 1. Bekijk alle entries
curl http://localhost:5000/api/entries

# 2. Voeg nieuwe entry toe
curl -X POST http://localhost:5000/api/entries -H "Content-Type: application/json" -d '{"naam":"Test User","bericht":"Hello API!"}'

# 3. Bekijk statistieken
curl http://localhost:5000/api/stats

# 4. Verwijder entry 2
curl -X DELETE http://localhost:5000/api/entries/2

# 5. Controleer dat het weg is
curl http://localhost:5000/api/entries
```

**Browser:** Ga naar `http://localhost:5000` en zie de veranderingen live!

---

## API Endpoints Overzicht

| Method | Endpoint | Beschrijving |
|--------|----------|--------------|
| GET | `/` | HTML interface (browser) |
| GET | `/api/entries` | Alle entries ophalen (JSON) |
| GET | `/api/entries/<id>` | Specifieke entry ophalen (JSON) |
| POST | `/api/entries` | Nieuwe entry toevoegen (JSON) |
| DELETE | `/api/entries/<id>` | Entry verwijderen (JSON) |
| GET | `/api/stats` | Statistieken ophalen (JSON) |

---

## HTML Form vs REST API

**HTML Form** (via browser):
- Gebruikt `POST` naar `/add`
- Form data (niet JSON)
- Redirect naar hoofdpagina
- Visueel en gebruiksvriendelijk

**REST API** (via curl/code):
- Gebruikt `/api/entries` endpoints
- JSON data
- JSON responses
- Programmatisch gebruik

**Beide werken op dezelfde data!**

---

## Stoppen
Druk `Ctrl+C` in de terminal waar de API draait.

## Extra Tip
Gebruik twee terminals tegelijk:
- **Terminal 1:** Run `python3 app.py`
- **Terminal 2:** Test met curl commands
- **Browser:** Zie de veranderingen live!
