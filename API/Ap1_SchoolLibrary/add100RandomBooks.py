#!/usr/bin/env python3
# ↑ Shebang: zegt tegen Linux dat dit script met Python 3 moet worden uitgevoerd

import requests
# ↑ Library om HTTP-requests te doen (GET, POST, DELETE, ...)

import json
# ↑ Library om Python-dictionaries om te zetten naar JSON en omgekeerd

from faker import Faker
# ↑ Library om fake data te genereren (titels, auteurs, ISBN, ...)


# Basis-URL van de School Library API
APIHOST = "http://library.demo.local"

# Login-gegevens voor Basic Authentication
LOGIN = "cisco"
PASSWORD = "Cisco123!"


def getAuthToken():
    # Deze functie logt in bij de API en haalt een token op

    # Tuple met username en password voor Basic Auth
    authCreds = (LOGIN, PASSWORD)

    # Stuur een POST request naar /loginViaBasic met Basic Auth
    r = requests.post(
        f"{APIHOST}/api/v1/loginViaBasic",
        auth=authCreds
    )

    # Controleer of de login gelukt is
    if r.status_code == 200:
        # Als het gelukt is, haal het token uit de JSON response
        # r.json() is een dictionary, ["token"] haalt de waarde van de key "token"
        return r.json()["token"]
    else:
        # Als het niet gelukt is, stop het programma met een foutmelding
        raise Exception(
            f"Status code {r.status_code} and text {r.text}, while trying to Auth."
        )


def addBook(book, apiKey):
    # Deze functie stuurt één boek naar de API om het toe te voegen

    # POST request naar /books
    r = requests.post(
        f"{APIHOST}/api/v1/books",

        # Headers sturen extra info mee met de request
        headers={
            # Zegt dat de data die we sturen JSON is
            "Content-type": "application/json",

            # API key (token) voor authenticatie
            "X-API-Key": apiKey
        },

        # De data (book) wordt omgezet van Python dict naar JSON tekst
        data=json.dumps(book)
    )

    # Controleer of het boek succesvol is toegevoegd
    if r.status_code == 200:
        # Succesbericht in de terminal
        print(f"Book {book} added.")
    else:
        # Foutmelding als het toevoegen mislukt
        raise Exception(
            f"Error code {r.status_code} and text {r.text}, while trying to add book {book}."
        )


# ---- HOOFDPROGRAMMA ----

# Haal eerst een token op via de login-functie
apiKey = getAuthToken()

# Maak een Faker-object aan om fake data te genereren
fake = Faker()

# Loop om meerdere boeken toe te voegen
# range(4, 104) betekent: ID's van 4 tot en met 103
for i in range(4, 104):

    # Maak een dictionary met boekgegevens
    book = {
        "id": i,                          # Unieke ID voor het boek
        "title": fake.catch_phrase(),     # Willekeurige boektitel
        "author": fake.name(),            # Willekeurige auteur
        "isbn": fake.isbn13()              # Willekeurig ISBN-nummer
    }

    # Stuur het boek naar de API
    addBook(book, apiKey)

