from flask import Flask, render_template, request, send_file, redirect, url_for
from PIL import Image, ImageFilter, ImageEnhance
import os
from werkzeug.utils import secure_filename
import io
import sqlite3
from datetime import datetime

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = 'uploads'
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16MB max file size
app.config['DATABASE'] = 'image_history.db'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'}

# Ensure upload folder exists
os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

def init_db():
    """Initialize SQLite database"""
    conn = sqlite3.connect(app.config['DATABASE'])
    cursor = conn.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS image_history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT NOT NULL,
            filter_type TEXT NOT NULL,
            file_size INTEGER,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    conn.commit()
    conn.close()

def log_image_processing(filename, filter_type, file_size):
    """Log image processing to database"""
    conn = sqlite3.connect(app.config['DATABASE'])
    cursor = conn.cursor()
    cursor.execute('''
        INSERT INTO image_history (filename, filter_type, file_size)
        VALUES (?, ?, ?)
    ''', (filename, filter_type, file_size))
    conn.commit()
    conn.close()

def get_history():
    """Get all processing history"""
    conn = sqlite3.connect(app.config['DATABASE'])
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()
    cursor.execute('''
        SELECT * FROM image_history
        ORDER BY timestamp DESC
        LIMIT 50
    ''')
    rows = cursor.fetchall()
    conn.close()
    return rows

def get_statistics():
    """Get filter usage statistics"""
    conn = sqlite3.connect(app.config['DATABASE'])
    conn.row_factory = sqlite3.Row
    cursor = conn.cursor()

    # Total processings
    cursor.execute('SELECT COUNT(*) as total FROM image_history')
    total = cursor.fetchone()['total']

    # Filter counts
    cursor.execute('''
        SELECT filter_type, COUNT(*) as count
        FROM image_history
        GROUP BY filter_type
        ORDER BY count DESC
    ''')
    filter_stats = cursor.fetchall()

    # Total file size processed
    cursor.execute('SELECT SUM(file_size) as total_size FROM image_history')
    total_size = cursor.fetchone()['total_size'] or 0

    conn.close()

    return {
        'total': total,
        'filter_stats': filter_stats,
        'total_size': total_size
    }

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/history')
def history():
    """Show processing history"""
    history_data = get_history()
    stats = get_statistics()
    return render_template('history.html', history=history_data, stats=stats)

@app.route('/upload', methods=['POST'])
def upload_file():
    if 'file' not in request.files:
        return redirect(url_for('index'))

    file = request.files['file']
    if file.filename == '':
        return redirect(url_for('index'))

    if file and allowed_file(file.filename):
        filename = secure_filename(file.filename)
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)

        # Get file size
        file_size = os.path.getsize(filepath)

        # Get selected filter
        filter_type = request.form.get('filter', 'original')

        # Log to database
        log_image_processing(filename, filter_type, file_size)

        # Process image
        processed_image = process_image(filepath, filter_type)

        # Save processed image to memory
        img_io = io.BytesIO()
        processed_image.save(img_io, 'PNG')
        img_io.seek(0)

        # Clean up uploaded file
        os.remove(filepath)

        return send_file(img_io, mimetype='image/png', as_attachment=True, download_name=f'processed_{filename}')

    return redirect(url_for('index'))

def process_image(filepath, filter_type):
    """Apply filter to image"""
    img = Image.open(filepath)

    if filter_type == 'grayscale':
        return img.convert('L').convert('RGB')

    elif filter_type == 'blur':
        return img.filter(ImageFilter.BLUR)

    elif filter_type == 'contour':
        return img.filter(ImageFilter.CONTOUR)

    elif filter_type == 'detail':
        return img.filter(ImageFilter.DETAIL)

    elif filter_type == 'edge_enhance':
        return img.filter(ImageFilter.EDGE_ENHANCE)

    elif filter_type == 'emboss':
        return img.filter(ImageFilter.EMBOSS)

    elif filter_type == 'sharpen':
        return img.filter(ImageFilter.SHARPEN)

    elif filter_type == 'smooth':
        return img.filter(ImageFilter.SMOOTH)

    elif filter_type == 'sepia':
        # Convert to sepia tone
        img = img.convert('RGB')
        width, height = img.size
        pixels = img.load()

        for py in range(height):
            for px in range(width):
                r, g, b = img.getpixel((px, py))

                tr = int(0.393 * r + 0.769 * g + 0.189 * b)
                tg = int(0.349 * r + 0.686 * g + 0.168 * b)
                tb = int(0.272 * r + 0.534 * g + 0.131 * b)

                if tr > 255:
                    tr = 255
                if tg > 255:
                    tg = 255
                if tb > 255:
                    tb = 255

                pixels[px, py] = (tr, tg, tb)

        return img

    elif filter_type == 'brightness':
        enhancer = ImageEnhance.Brightness(img)
        return enhancer.enhance(1.5)

    elif filter_type == 'contrast':
        enhancer = ImageEnhance.Contrast(img)
        return enhancer.enhance(1.5)

    elif filter_type == 'rotate90':
        return img.rotate(90, expand=True)

    elif filter_type == 'rotate180':
        return img.rotate(180)

    elif filter_type == 'rotate270':
        return img.rotate(270, expand=True)

    elif filter_type == 'flip_horizontal':
        return img.transpose(Image.FLIP_LEFT_RIGHT)

    elif filter_type == 'flip_vertical':
        return img.transpose(Image.FLIP_TOP_BOTTOM)

    elif filter_type == 'thumbnail':
        img.thumbnail((200, 200))
        return img

    else:  # original
        return img

if __name__ == '__main__':
    # Initialize database on startup
    init_db()
    app.run(host='0.0.0.0', port=8080, debug=False, threaded=False)
