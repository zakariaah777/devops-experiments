#!/usr/bin/env python3
from flask import Flask, render_template, request
import requests

app = Flask(__name__)

# PokeAPI basis URL
POKEAPI_URL = "https://pokeapi.co/api/v2/pokemon/"

@app.route('/', methods=['GET', 'POST'])
def index():
    pokemon_data = None
    error = None

    if request.method == 'POST':
        pokemon_naam = request.form.get('pokemon_naam', '').lower().strip()

        if pokemon_naam:
            try:
                # Haal Pokemon data op
                response = requests.get(f"{POKEAPI_URL}{pokemon_naam}")

                if response.status_code == 200:
                    data = response.json()

                    # Verzamel relevante informatie
                    pokemon_data = {
                        'naam': data['name'].capitalize(),
                        'id': data['id'],
                        'hoogte': data['height'] / 10,  # Decimeters naar meters
                        'gewicht': data['weight'] / 10,  # Hectograms naar kg
                        'types': [t['type']['name'].capitalize() for t in data['types']],
                        'sprite': data['sprites']['front_default'],
                        'sprite_shiny': data['sprites']['front_shiny'],
                        'stats': [
                            {
                                'naam': stat['stat']['name'].replace('-', ' ').title(),
                                'waarde': stat['base_stat']
                            }
                            for stat in data['stats']
                        ],
                        'abilities': [
                            a['ability']['name'].replace('-', ' ').title()
                            for a in data['abilities']
                        ]
                    }
                else:
                    error = f"Pokemon '{pokemon_naam}' niet gevonden! Probeer een andere naam."

            except requests.exceptions.RequestException as e:
                error = "Fout bij verbinding met PokeAPI. Probeer het later opnieuw."
            except Exception as e:
                error = f"Er is een fout opgetreden: {str(e)}"
        else:
            error = "Voer een Pokemon naam in!"

    return render_template('index.html', pokemon=pokemon_data, error=error)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
