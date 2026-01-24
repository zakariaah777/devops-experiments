#!/usr/bin/env python3
from flask import Flask, jsonify, request, render_template, redirect, url_for
from datetime import datetime

app = Flask(__name__)

# In-memory gastenboek (lijst met entries)
gastenboek = [
    {
        'id': 1,
        'naam': 'Alice',
        'bericht': 'Geweldige website! Echt super gedaan.',
        'timestamp': '2024-01-24T10:00:00'
    },
    {
        'id': 2,
        'naam': 'Bob',
        'bericht': 'Bedankt voor deze handige tool!',
        'timestamp': '2024-01-24T11:30:00'
    }
]

# Volgende ID
volgende_id = 3


# ========== HTML ROUTES (Browser) ==========

@app.route('/')
def index():
    """Toon gastenboek met formulier (HTML)"""
    return render_template('index.html', entries=gastenboek)


@app.route('/add', methods=['POST'])
def add_entry_form():
    """Voeg entry toe via HTML formulier"""
    naam = request.form.get('naam', '').strip()
    bericht = request.form.get('bericht', '').strip()

    if naam and bericht:
        global volgende_id
        nieuwe_entry = {
            'id': volgende_id,
            'naam': naam,
            'bericht': bericht,
            'timestamp': datetime.now().isoformat()
        }
        gastenboek.append(nieuwe_entry)
        volgende_id += 1

    return redirect(url_for('index'))


# ========== REST API ENDPOINTS (JSON) ==========

@app.route('/api/entries', methods=['GET'])
def get_entries():
    """API: Haal alle gastenboek entries op (JSON)"""
    return jsonify({
        'totaal': len(gastenboek),
        'entries': gastenboek
    }), 200


@app.route('/api/entries/<int:entry_id>', methods=['GET'])
def get_entry(entry_id):
    """API: Haal specifieke entry op (JSON)"""
    entry = next((e for e in gastenboek if e['id'] == entry_id), None)

    if entry is None:
        return jsonify({'error': f'Entry met id {entry_id} niet gevonden'}), 404

    return jsonify(entry), 200


@app.route('/api/entries', methods=['POST'])
def create_entry():
    """API: Maak nieuwe entry aan (JSON)"""
    global volgende_id

    if not request.json:
        return jsonify({'error': 'Request moet JSON bevatten'}), 400

    if 'naam' not in request.json or 'bericht' not in request.json:
        return jsonify({'error': 'Naam en bericht zijn verplicht'}), 400

    nieuwe_entry = {
        'id': volgende_id,
        'naam': request.json['naam'],
        'bericht': request.json['bericht'],
        'timestamp': datetime.now().isoformat()
    }

    gastenboek.append(nieuwe_entry)
    volgende_id += 1

    return jsonify({
        'bericht': 'Entry succesvol toegevoegd',
        'entry': nieuwe_entry
    }), 201


@app.route('/api/entries/<int:entry_id>', methods=['DELETE'])
def delete_entry(entry_id):
    """API: Verwijder entry (JSON)"""
    global gastenboek

    entry = next((e for e in gastenboek if e['id'] == entry_id), None)

    if entry is None:
        return jsonify({'error': f'Entry met id {entry_id} niet gevonden'}), 404

    gastenboek = [e for e in gastenboek if e['id'] != entry_id]

    return jsonify({
        'bericht': f'Entry {entry_id} succesvol verwijderd',
        'verwijderde_entry': entry
    }), 200


@app.route('/api/stats', methods=['GET'])
def get_stats():
    """API: Haal statistieken op (JSON)"""
    return jsonify({
        'totaal_entries': len(gastenboek),
        'laatste_entry': gastenboek[-1] if gastenboek else None
    }), 200


if __name__ == '__main__':
    print("📖 Gastenboek API gestart!")
    print("🌐 Browser: http://localhost:5000")
    print("🔧 API endpoints: http://localhost:5000/api/entries")
    print("📚 Zie README.md voor curl voorbeelden")
    app.run(debug=True, host='0.0.0.0', port=5000)
