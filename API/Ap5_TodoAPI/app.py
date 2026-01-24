#!/usr/bin/env python3
from flask import Flask, jsonify, request
from datetime import datetime

app = Flask(__name__)

# In-memory todo storage (lijst met dictionaries)
todos = [
    {
        'id': 1,
        'titel': 'Flask leren',
        'beschrijving': 'REST API bouwen met Flask',
        'voltooid': False,
        'aangemaakt': '2024-01-24T10:00:00'
    },
    {
        'id': 2,
        'titel': 'Docker installeren',
        'beschrijving': 'Docker setup voor DevOps',
        'voltooid': True,
        'aangemaakt': '2024-01-24T11:00:00'
    }
]

# Volgende ID voor nieuwe todos
volgende_id = 3


@app.route('/')
def index():
    """Welkomstpagina met API documentatie"""
    return jsonify({
        'bericht': 'Welkom bij de Todo API!',
        'versie': '1.0',
        'endpoints': {
            'GET /todos': 'Haal alle todos op',
            'GET /todos/<id>': 'Haal specifieke todo op',
            'POST /todos': 'Maak nieuwe todo (JSON body: titel, beschrijving)',
            'PUT /todos/<id>': 'Update todo (JSON body: titel, beschrijving, voltooid)',
            'DELETE /todos/<id>': 'Verwijder todo'
        }
    })


@app.route('/todos', methods=['GET'])
def get_todos():
    """Haal alle todos op"""
    return jsonify({
        'totaal': len(todos),
        'todos': todos
    }), 200


@app.route('/todos/<int:todo_id>', methods=['GET'])
def get_todo(todo_id):
    """Haal specifieke todo op"""
    todo = next((t for t in todos if t['id'] == todo_id), None)

    if todo is None:
        return jsonify({'error': f'Todo met id {todo_id} niet gevonden'}), 404

    return jsonify(todo), 200


@app.route('/todos', methods=['POST'])
def create_todo():
    """Maak nieuwe todo aan"""
    global volgende_id

    if not request.json:
        return jsonify({'error': 'Request moet JSON bevatten'}), 400

    if 'titel' not in request.json:
        return jsonify({'error': 'Titel is verplicht'}), 400

    nieuwe_todo = {
        'id': volgende_id,
        'titel': request.json['titel'],
        'beschrijving': request.json.get('beschrijving', ''),
        'voltooid': False,
        'aangemaakt': datetime.now().isoformat()
    }

    todos.append(nieuwe_todo)
    volgende_id += 1

    return jsonify({
        'bericht': 'Todo succesvol aangemaakt',
        'todo': nieuwe_todo
    }), 201


@app.route('/todos/<int:todo_id>', methods=['PUT'])
def update_todo(todo_id):
    """Update bestaande todo"""
    todo = next((t for t in todos if t['id'] == todo_id), None)

    if todo is None:
        return jsonify({'error': f'Todo met id {todo_id} niet gevonden'}), 404

    if not request.json:
        return jsonify({'error': 'Request moet JSON bevatten'}), 400

    # Update velden als ze aanwezig zijn in request
    if 'titel' in request.json:
        todo['titel'] = request.json['titel']
    if 'beschrijving' in request.json:
        todo['beschrijving'] = request.json['beschrijving']
    if 'voltooid' in request.json:
        todo['voltooid'] = request.json['voltooid']

    return jsonify({
        'bericht': 'Todo succesvol geupdate',
        'todo': todo
    }), 200


@app.route('/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    """Verwijder todo"""
    global todos

    todo = next((t for t in todos if t['id'] == todo_id), None)

    if todo is None:
        return jsonify({'error': f'Todo met id {todo_id} niet gevonden'}), 404

    todos = [t for t in todos if t['id'] != todo_id]

    return jsonify({
        'bericht': f'Todo {todo_id} succesvol verwijderd',
        'verwijderde_todo': todo
    }), 200


@app.route('/todos/stats', methods=['GET'])
def get_stats():
    """Haal statistieken op"""
    totaal = len(todos)
    voltooid = len([t for t in todos if t['voltooid']])
    nog_te_doen = totaal - voltooid

    return jsonify({
        'totaal_todos': totaal,
        'voltooid': voltooid,
        'nog_te_doen': nog_te_doen,
        'percentage_voltooid': round((voltooid / totaal * 100) if totaal > 0 else 0, 2)
    }), 200


if __name__ == '__main__':
    print("🚀 Todo API gestart!")
    print("📍 API draait op: http://localhost:5000")
    print("📖 Zie README.md voor curl voorbeelden")
    app.run(debug=True, host='0.0.0.0', port=5000)
