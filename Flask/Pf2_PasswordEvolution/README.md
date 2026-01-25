# Pf2 – Password Evolution Lab

## Wat doet dit?
Flask app die het verschil toont tussen **plaintext** en **hashed** password storage. Lab 6.5.10 - Explore the Evolution of Password Methods.

## Vereisten
```bash
pip3 install flask pyotp
```

## Uitvoeren

### Start de server
```bash
cd Flask/Pf2_PasswordEvolution

# Run server (draait in achtergrond)
nohup python3 password-evolution.py &
```

Server draait op: `https://0.0.0.0:5000`

---

## Testen

### Methode 1: Plaintext Passwords (ONVEILIG)

**Gebruiker aanmaken:**
```bash
curl -k -X POST -F 'username=alice' -F 'password=mypassword' 'https://0.0.0.0:5000/signup/v1'
```

**Inloggen:**
```bash
curl -k -X POST -F 'username=alice' -F 'password=mypassword' 'https://0.0.0.0:5000/login/v1'
```

**Resultaat:** Wachtwoord staat in database als **plaintext** (leesbaar!)

---

### Methode 2: Hashed Passwords (VEILIG)

**Gebruiker aanmaken:**
```bash
curl -k -X POST -F 'username=bob' -F 'password=secretpass' 'https://0.0.0.0:5000/signup/v2'
```

**Inloggen:**
```bash
curl -k -X POST -F 'username=bob' -F 'password=secretpass' 'https://0.0.0.0:5000/login/v2'
```

**Resultaat:** Wachtwoord staat in database als **SHA256 hash** (onleesbaar!)

---

## Server stoppen
```bash
pkill -f password-evolution.py
```

## Database bekijken (optioneel)

Na het aanmaken van users staat er een `test.db` bestand in de directory.

**Installeer DB Browser:**
```bash
sudo apt-get install sqlitebrowser
```

**Open database:**
```bash
sqlitebrowser test.db
```

Je ziet twee tabellen:
- **USER_PLAIN** - Plaintext passwords (zichtbaar!)
- **USER_HASH** - Hashed passwords (onleesbaar hash)

---

## Het verschil

| Methode | Versie | Database | Veiligheid |
|---------|--------|----------|------------|
| Plaintext | v1 | Leesbaar wachtwoord | ❌ ONVEILIG |
| Hashing | v2 | SHA256 hash | ✅ VEILIG |

**Les:** Gebruik ALTIJD hashing voor wachtwoorden! Nooit plaintext opslaan.
