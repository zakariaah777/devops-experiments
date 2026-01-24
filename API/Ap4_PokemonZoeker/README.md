# Ap4 – Pokemon Zoeker Webapp

## Wat doet dit?
Een webapplicatie gebouwd met **Flask** waar je Pokemon kunt opzoeken. Toont informatie zoals types, stats, abilities, hoogte, gewicht en sprites (normal + shiny).

## Vereisten
```bash
pip3 install flask requests
```

## Uitvoeren
```bash
cd API/Ap4_PokemonZoeker
python3 app.py
```

De webapp draait op: **http://localhost:5000**

## Gebruik
1. Open je browser en ga naar `http://localhost:5000`
2. Voer een Pokemon naam in (bijv. `pikachu`, `charizard`, `mewtwo`)
3. Klik op "Zoeken"
4. Bekijk de Pokemon info, sprites en stats!

**Tip:** Probeer ook nummers! (bijv. `25` voor Pikachu, `1` voor Bulbasaur)

## Features
- ✅ Zoek Pokemon op naam of nummer
- ✅ Toont normal en shiny sprites
- ✅ Types met kleuren
- ✅ Base stats met visuele balken
- ✅ Hoogte, gewicht en abilities
- ✅ Responsive design

## API
Gebruikt de gratis **PokeAPI**: https://pokeapi.co/
Geen API key nodig! ✅

## Stoppen
Druk `Ctrl+C` in de terminal om de server te stoppen.
