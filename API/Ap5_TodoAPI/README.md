# Ap5 – Todo List REST API

## Wat doet dit?
Een **zelfgemaakte REST API** gebouwd met Flask. Bevat endpoints om todos te beheren (CRUD operaties). Test de API met **curl** commando's.

## Vereisten
```bash
pip3 install flask
```

## Uitvoeren
```bash
cd API/Ap5_TodoAPI
python3 app.py
```

API draait op: **http://localhost:5000**

---

## API Endpoints

### 1. Welkomstpagina (Documentatie)
```bash
curl http://localhost:5000/
```

### 2. Alle todos ophalen (GET)
```bash
curl http://localhost:5000/todos
```

### 3. Specifieke todo ophalen (GET)
```bash
curl http://localhost:5000/todos/1
```

### 4. Nieuwe todo aanmaken (POST)
```bash
curl -X POST http://localhost:5000/todos \
  -H "Content-Type: application/json" \
  -d '{
    "titel": "DevOps oefening maken",
    "beschrijving": "REST API bouwen en testen"
  }'
```

**Simpeler (één regel):**
```bash
curl -X POST http://localhost:5000/todos -H "Content-Type: application/json" -d '{"titel":"Python leren","beschrijving":"Flask tutorial voltooien"}'
```

### 5. Todo updaten (PUT)
```bash
curl -X PUT http://localhost:5000/todos/1 \
  -H "Content-Type: application/json" \
  -d '{
    "titel": "Flask leren (UPDATED)",
    "voltooid": true
  }'
```

**Alleen status wijzigen:**
```bash
curl -X PUT http://localhost:5000/todos/2 -H "Content-Type: application/json" -d '{"voltooid":true}'
```

### 6. Todo verwijderen (DELETE)
```bash
curl -X DELETE http://localhost:5000/todos/1
```

### 7. Statistieken ophalen (GET)
```bash
curl http://localhost:5000/todos/stats
```

---

## Testen - Volledige Workflow

**Stap 1:** Start de API
```bash
python3 app.py
```

**Stap 2:** Open een NIEUWE terminal en test:

```bash
# 1. Bekijk alle todos
curl http://localhost:5000/todos

# 2. Maak nieuwe todo
curl -X POST http://localhost:5000/todos -H "Content-Type: application/json" -d '{"titel":"Git leren","beschrijving":"Branches en merging oefenen"}'

# 3. Bekijk weer alle todos (je ziet de nieuwe!)
curl http://localhost:5000/todos

# 4. Update todo 3 naar voltooid
curl -X PUT http://localhost:5000/todos/3 -H "Content-Type: application/json" -d '{"voltooid":true}'

# 5. Bekijk statistieken
curl http://localhost:5000/todos/stats

# 6. Verwijder todo 1
curl -X DELETE http://localhost:5000/todos/1

# 7. Controleer dat het weg is
curl http://localhost:5000/todos
```

---

## HTTP Methods Uitleg

- **GET** - Gegevens ophalen (lezen)
- **POST** - Nieuwe gegevens aanmaken
- **PUT** - Bestaande gegevens updaten
- **DELETE** - Gegevens verwijderen

## Response Codes

- **200** - OK (succesvol)
- **201** - Created (nieuw item aangemaakt)
- **404** - Not Found (item bestaat niet)
- **400** - Bad Request (ongeldige data)

---

## Stoppen
Druk `Ctrl+C` in de terminal waar de API draait.

## Tip
Gebruik `-v` flag voor verbose output (zie headers):
```bash
curl -v http://localhost:5000/todos
```
