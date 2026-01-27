# Pf2 – Password Evolution

## Wat doet dit?
Toont verschil tussen plaintext (ONVEILIG) en hashed (VEILIG) passwords.

## Stap 1: Ga naar de directory
```bash
cd Flask/Pf2_PasswordEvolution
```

## Stap 2: Installeer packages (als je ze nog niet hebt)
```bash
pip3 install flask pyotp
```

## Stap 3: Start de app (draait in achtergrond)
```bash
nohup python3 password-evolution.py &
```

Je ziet:
```
[1] 12345
nohup: ignoring input and appending output to 'nohup.out'
```

## Stap 4: Test de app

### Optie A: Browser
1. Ga naar `https://0.0.0.0:5000/signup/v2`
2. Accept de security warning (klik Advanced > Accept Risk)
3. Vul username en password in
4. Klik "Sign Up"
5. Je ziet: "signup success"

### Optie B: Curl commands
```bash
# Maak user aan (v2 = veilig met hash)
curl -k -X POST -F 'username=bob' -F 'password=test123' 'https://0.0.0.0:5000/signup/v2'

# Log in
curl -k -X POST -F 'username=bob' -F 'password=test123' 'https://0.0.0.0:5000/login/v2'
```

Je ziet: "signup success" en "login success"

## Stap 5: Stoppen
```bash
pkill -f password-evolution.py
```

---

## Verschil v1 vs v2
- **v1** = plaintext wachtwoord in database (ONVEILIG - iedereen kan lezen)
- **v2** = SHA256 hash in database (VEILIG - niemand kan origineel wachtwoord zien)
