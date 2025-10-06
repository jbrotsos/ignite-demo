"""
Vulnerable Flask Application for Security Testing
WARNING: This application contains intentional security vulnerabilities
DO NOT deploy to production environments
"""

import os
import pickle
import hashlib
import subprocess
from flask import Flask, request, jsonify, render_template_string
import sqlite3
import base64

app = Flask(__name__)

# VULNERABILITY 1: Hardcoded secrets
API_KEY = "sk-1234567890abcdef"
DB_PASSWORD = "SuperSecretPassword123!"
AWS_ACCESS_KEY = "AKIAIOSFODNN7EXAMPLE"
AWS_SECRET_KEY = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

# VULNERABILITY 2: Weak cryptographic practice
def hash_password(password):
    """Uses weak MD5 hashing"""
    return hashlib.md5(password.encode()).hexdigest()

# VULNERABILITY 3: SQL Injection vulnerability
@app.route('/user/<username>')
def get_user(username):
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    # Direct string concatenation - SQL injection vulnerability
    query = f"SELECT * FROM users WHERE username = '{username}'"
    cursor.execute(query)
    result = cursor.fetchall()
    conn.close()
    return jsonify(result)

# VULNERABILITY 4: Command Injection vulnerability
@app.route('/ping', methods=['POST'])
def ping_server():
    host = request.form.get('host', '')
    # Unsafe command execution
    result = subprocess.check_output(f'ping -n 1 {host}', shell=True)
    return result.decode()

# VULNERABILITY 5: Insecure deserialization
@app.route('/deserialize', methods=['POST'])
def deserialize_data():
    data = request.form.get('data', '')
    # Unsafe pickle deserialization
    decoded = base64.b64decode(data)
    obj = pickle.loads(decoded)
    return jsonify({'result': str(obj)})

# VULNERABILITY 6: Use of eval() - code injection
@app.route('/calc', methods=['POST'])
def calculate():
    expression = request.form.get('expr', '')
    # Dangerous use of eval
    result = eval(expression)
    return jsonify({'result': result})

# VULNERABILITY 7: Server-Side Template Injection (SSTI)
@app.route('/hello/<name>')
def hello(name):
    # Template injection vulnerability
    template = f'<h1>Hello {name}!</h1>'
    return render_template_string(template)

# VULNERABILITY 8: Information disclosure
@app.route('/debug')
def debug_info():
    return jsonify({
        'api_key': API_KEY,
        'db_password': DB_PASSWORD,
        'aws_key': AWS_ACCESS_KEY,
        'environment': dict(os.environ)
    })

# VULNERABILITY 9: Insecure file upload
@app.route('/upload', methods=['POST'])
def upload_file():
    file = request.files['file']
    # No validation of file type or content
    filename = file.filename
    file.save(f'uploads/{filename}')
    return jsonify({'message': 'File uploaded successfully'})

# VULNERABILITY 10: Missing authentication
@app.route('/admin/delete/<user_id>')
def delete_user(user_id):
    # No authentication check
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    cursor.execute(f"DELETE FROM users WHERE id = {user_id}")
    conn.commit()
    conn.close()
    return jsonify({'message': 'User deleted'})

# VULNERABILITY 11: Insecure direct object reference
@app.route('/file/<path>')
def read_file(path):
    # Path traversal vulnerability
    with open(path, 'r') as f:
        content = f.read()
    return content

# VULNERABILITY 12: XXE vulnerability
@app.route('/parse-xml', methods=['POST'])
def parse_xml():
    import xml.etree.ElementTree as ET
    xml_data = request.data
    # Vulnerable to XXE attacks
    root = ET.fromstring(xml_data)
    return jsonify({'parsed': ET.tostring(root).decode()})

@app.route('/')
def index():
    return '''
    <h1>Vulnerable Web Application</h1>
    <p>This application contains intentional security vulnerabilities for testing.</p>
    <ul>
        <li>SQL Injection: /user/&lt;username&gt;</li>
        <li>Command Injection: /ping</li>
        <li>Code Injection: /calc</li>
        <li>Template Injection: /hello/&lt;name&gt;</li>
        <li>Insecure Deserialization: /deserialize</li>
        <li>Debug Info: /debug</li>
    </ul>
    '''

if __name__ == '__main__':
    # VULNERABILITY 13: Debug mode enabled in production
    app.run(host='0.0.0.0', port=5000, debug=True)
