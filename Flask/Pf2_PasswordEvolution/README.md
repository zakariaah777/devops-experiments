# Pf2 – Password Evolution

## Wat doet dit?
Toont verschil tussen plaintext en hashed passwords.

## Hoe run je dit?

```bash
cd Flask/Pf2_PasswordEvolution
nohup python3 password-evolution.py &
```

## Hoe test je dit?

**Browser:**
- Ga naar `https://0.0.0.0:5000/signup/v2`
- Vul username en password in
- Klik Sign Up

**Of met curl:**
```bash
# Maak user aan (v2 = veilig met hash)
curl -k -X POST -F 'username=bob' -F 'password=test123' 'https://0.0.0.0:5000/signup/v2'

# Log in
curl -k -X POST -F 'username=bob' -F 'password=test123' 'https://0.0.0.0:5000/login/v2'
```

## Wat zie je?
- Je krijgt "signup success" en "login success"
- v1 = plaintext wachtwoord (ONVEILIG)
- v2 = SHA256 hash (VEILIG)

## Stoppen
```bash
pkill -f password-evolution.py
```
