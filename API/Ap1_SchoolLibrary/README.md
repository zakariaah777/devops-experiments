# Ap1 – School Library API

## Context
Dit experiment maakt deel uit van het vak **DevOps** en is gebaseerd op  
**Lab 4.5.5 – School Library API** uit de NetAcad cursus.

De School Library API is een REST API waarmee boeken kunnen worden:
- opgevraagd (GET)
- toegevoegd (POST)
- verwijderd (DELETE)

Sommige endpoints zijn beveiligd en vereisen authenticatie via een token.

---

## Doel van het experiment
Het doel van dit experiment is:
- begrijpen hoe een REST API werkt
- werken met HTTP-methodes (POST)
- authenticatie met **Basic Auth** en **API token**
- API-calls automatiseren met **Python**

---

## Authenticatieprincipe
De authenticatie gebeurt in twee stappen:

1. **POST /loginViaBasic**
   - Username en password worden meegestuurd via Basic Authentication
   - De API stuurt een **token** terug

2. **POST /books**
   - Dit endpoint vereist het token
   - Het token wordt meegestuurd in de HTTP headers als:
     ```
     X-API-Key: <token>
     ```

Zonder geldig token geeft de API een **401 Unauthorized** fout.

---

## Beschrijving van het script
Het Python-script `add100RandomBooks.py` automatiseert het toevoegen van boeken.

Het script:
1. Logt in bij de API via `POST /loginViaBasic`
2. Ontvangt een token
3. Gebruikt de `faker` library om willekeurige:
   - boektitels
   - auteurs
   - ISBN-nummers  
   te genereren
4. Stuurt deze gegevens als JSON naar `POST /books`
5. Voegt automatisch meerdere boeken toe via een loop

---

## Gebruikte technologieën
- **Python 3**
- **requests**: uitvoeren van HTTP requests
- **json**: omzetten van Python data naar JSON
- **faker**: genereren van willekeurige testdata
- **REST API**
- **HTTP headers en statuscodes**

---

## Resultaat
Na het uitvoeren van het script:
- zijn meerdere nieuwe boeken toegevoegd aan de School Library
- zijn de boeken zichtbaar via:
  - de webinterface
  - de `GET /books` API-call

Dit toont aan dat:
- de authenticatie correct werkt
- de API correct werd aangesproken
- automatisatie via Python succesvol is

---

## Conclusie
Dit experiment toont hoe REST API’s:
- beveiligd worden met tokens
- getest kunnen worden met Postman
- geautomatiseerd kunnen worden met Python

Het experiment bevestigt het correct gebruik van:
- API documentatie
- HTTP-methodes
- authenticatie en headers
API experiments (to be added later)
	
