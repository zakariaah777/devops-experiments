import sqlite3
import string
import random
from flask import Flask, request, redirect, render_template_string

app = Flask(__name__)
db_name = 'urls.db'

def init_db():
    """Maak database en tabel aan"""
    conn = sqlite3.connect(db_name)
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS urls
                 (code TEXT PRIMARY KEY,
                  url TEXT NOT NULL,
                  clicks INTEGER DEFAULT 0)''')
    conn.commit()
    conn.close()

def generate_code(length=6):
    """Genereer random code voor de URL"""
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

@app.route('/')
def index():
    """Homepage met formulier"""
    return render_template_string('''
        <!DOCTYPE html>
        <html>
        <head>
            <title>URL Shortener</title>
            <style>
                body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
                input[type="text"] { width: 100%; padding: 10px; margin: 10px 0; }
                button { padding: 10px 20px; background: #007bff; color: white; border: none; cursor: pointer; }
                button:hover { background: #0056b3; }
                .result { margin-top: 20px; padding: 15px; background: #d4edda; border-radius: 5px; }
            </style>
        </head>
        <body>
            <h1>URL Shortener Microservice</h1>
            <p>Verkort lange URLs naar korte links!</p>

            <form action="/shorten" method="POST">
                <label>Lange URL:</label>
                <input type="text" name="url" placeholder="https://example.com/very/long/url" required>
                <button type="submit">Verkort URL</button>
            </form>

            <hr>
            <h3>API Gebruik:</h3>
            <pre>
# Verkort een URL
curl -X POST -F 'url=https://example.com' http://0.0.0.0:5000/shorten

# Gebruik de korte URL in browser
http://0.0.0.0:5000/{code}
            </pre>
        </body>
        </html>
    ''')

@app.route('/shorten', methods=['POST'])
def shorten():
    """Verkort een URL"""
    url = request.form.get('url')

    if not url:
        return "Error: Geen URL opgegeven", 400

    # Voeg http:// toe als het ontbreekt
    if not url.startswith(('http://', 'https://')):
        url = 'http://' + url

    # Genereer unieke code
    code = generate_code()

    # Check of code al bestaat
    conn = sqlite3.connect(db_name)
    c = conn.cursor()

    while True:
        c.execute("SELECT code FROM urls WHERE code = ?", (code,))
        if not c.fetchone():
            break
        code = generate_code()

    # Sla URL op
    c.execute("INSERT INTO urls (code, url) VALUES (?, ?)", (code, url))
    conn.commit()
    conn.close()

    short_url = f"http://0.0.0.0:5000/{code}"

    # Als het een browser request is, toon HTML
    if request.headers.get('Content-Type') == 'application/x-www-form-urlencoded':
        return render_template_string('''
            <!DOCTYPE html>
            <html>
            <head>
                <title>URL Verkort!</title>
                <style>
                    body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
                    .result { margin-top: 20px; padding: 15px; background: #d4edda; border-radius: 5px; }
                    .url { font-size: 18px; color: #007bff; word-break: break-all; }
                    a { color: #007bff; text-decoration: none; }
                </style>
            </head>
            <body>
                <h1>✅ URL Verkort!</h1>
                <div class="result">
                    <p><strong>Originele URL:</strong><br>{{ original_url }}</p>
                    <p><strong>Korte URL:</strong><br>
                    <span class="url"><a href="{{ short_url }}">{{ short_url }}</a></span></p>
                    <p><strong>Code:</strong> {{ code }}</p>
                </div>
                <br>
                <a href="/">← Terug naar home</a>
            </body>
            </html>
        ''', original_url=url, short_url=short_url, code=code)

    # Voor API requests, return plain text
    return f"Short URL: {short_url}\nCode: {code}\nOriginal: {url}"

@app.route('/<code>')
def redirect_to_url(code):
    """Redirect naar originele URL"""
    conn = sqlite3.connect(db_name)
    c = conn.cursor()

    # Haal URL op en update clicks
    c.execute("SELECT url FROM urls WHERE code = ?", (code,))
    result = c.fetchone()

    if not result:
        conn.close()
        return "Error: Code niet gevonden", 404

    url = result[0]

    # Update click counter
    c.execute("UPDATE urls SET clicks = clicks + 1 WHERE code = ?", (code,))
    conn.commit()
    conn.close()

    return redirect(url)

@app.route('/stats/<code>')
def stats(code):
    """Toon statistieken voor een URL"""
    conn = sqlite3.connect(db_name)
    c = conn.cursor()

    c.execute("SELECT url, clicks FROM urls WHERE code = ?", (code,))
    result = c.fetchone()
    conn.close()

    if not result:
        return "Error: Code niet gevonden", 404

    url, clicks = result

    return render_template_string('''
        <!DOCTYPE html>
        <html>
        <head>
            <title>URL Stats</title>
            <style>
                body { font-family: Arial; max-width: 600px; margin: 50px auto; padding: 20px; }
                .stats { background: #f8f9fa; padding: 20px; border-radius: 5px; }
            </style>
        </head>
        <body>
            <h1>📊 URL Statistieken</h1>
            <div class="stats">
                <p><strong>Code:</strong> {{ code }}</p>
                <p><strong>Originele URL:</strong><br>{{ url }}</p>
                <p><strong>Aantal clicks:</strong> {{ clicks }}</p>
                <p><strong>Korte URL:</strong><br>http://0.0.0.0:5000/{{ code }}</p>
            </div>
            <br>
            <a href="/">← Terug naar home</a>
        </body>
        </html>
    ''', code=code, url=url, clicks=clicks)

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
