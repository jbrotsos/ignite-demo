#!/bin/bash

# Setup Script for Vulnerable Web Application (Linux/Mac)

echo "=== Vulnerable Web Application Setup ==="
echo "WARNING: This application contains intentional vulnerabilities"
echo ""

# Check Python installation
echo "Checking Python installation..."
if ! command -v python3 &> /dev/null; then
    echo "ERROR: Python 3 is not installed"
    exit 1
fi
python_version=$(python3 --version)
echo "Found: $python_version"
echo ""

# Create virtual environment
echo "Creating Python virtual environment..."
if [ -d "venv" ]; then
    echo "Virtual environment already exists, skipping..."
else
    python3 -m venv venv
    echo "Virtual environment created successfully!"
fi
echo ""

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo ""

# Install dependencies
echo "Installing Python dependencies..."
pip install --upgrade pip
pip install -r requirements.txt
echo ""

# Install security scanning tools
echo "Installing security scanning tools..."
pip install bandit checkov
echo ""

# Initialize database
echo "Initializing database..."
python init_db.py
echo ""

# Create uploads directory
echo "Creating uploads directory..."
mkdir -p uploads
echo "Uploads directory created!"
echo ""

# Display next steps
echo "=== Setup Complete! ==="
echo ""
echo "Next steps:"
echo "1. Run the application locally:"
echo "   python app.py"
echo ""
echo "2. Run security scans:"
echo "   bandit -r . -f txt"
echo "   checkov -d . --framework terraform,dockerfile"
echo ""
echo "3. Test with Docker:"
echo "   docker-compose up --build"
echo ""
echo "4. View the application at:"
echo "   http://localhost:5000"
echo ""
echo "WARNING: This is a vulnerable application for testing only!"
echo "Do not deploy to production environments."
echo ""
