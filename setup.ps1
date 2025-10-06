# Setup Script for Vulnerable Web Application

Write-Host "=== Vulnerable Web Application Setup ===" -ForegroundColor Cyan
Write-Host "WARNING: This application contains intentional vulnerabilities" -ForegroundColor Yellow
Write-Host ""

# Check Python installation
Write-Host "Checking Python installation..." -ForegroundColor Green
$pythonVersion = python --version 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    exit 1
}
Write-Host "Found: $pythonVersion" -ForegroundColor Green
Write-Host ""

# Create virtual environment
Write-Host "Creating Python virtual environment..." -ForegroundColor Green
if (Test-Path "venv") {
    Write-Host "Virtual environment already exists, skipping..." -ForegroundColor Yellow
} else {
    python -m venv venv
    Write-Host "Virtual environment created successfully!" -ForegroundColor Green
}
Write-Host ""

# Activate virtual environment
Write-Host "Activating virtual environment..." -ForegroundColor Green
& ".\venv\Scripts\Activate.ps1"
Write-Host ""

# Install dependencies
Write-Host "Installing Python dependencies..." -ForegroundColor Green
pip install --upgrade pip
pip install -r requirements.txt
Write-Host ""

# Install security scanning tools
Write-Host "Installing security scanning tools..." -ForegroundColor Green
pip install bandit checkov
Write-Host ""

# Initialize database
Write-Host "Initializing database..." -ForegroundColor Green
python init_db.py
Write-Host ""

# Create uploads directory
Write-Host "Creating uploads directory..." -ForegroundColor Green
if (-not (Test-Path "uploads")) {
    New-Item -ItemType Directory -Path "uploads" | Out-Null
    Write-Host "Uploads directory created!" -ForegroundColor Green
} else {
    Write-Host "Uploads directory already exists" -ForegroundColor Yellow
}
Write-Host ""

# Display next steps
Write-Host "=== Setup Complete! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Green
Write-Host "1. Run the application locally:" -ForegroundColor White
Write-Host "   python app.py" -ForegroundColor Cyan
Write-Host ""
Write-Host "2. Run security scans:" -ForegroundColor White
Write-Host "   bandit -r . -f txt" -ForegroundColor Cyan
Write-Host "   checkov -d . --framework terraform,dockerfile" -ForegroundColor Cyan
Write-Host ""
Write-Host "3. Test with Docker:" -ForegroundColor White
Write-Host "   docker-compose up --build" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. View the application at:" -ForegroundColor White
Write-Host "   http://localhost:5000" -ForegroundColor Cyan
Write-Host ""
Write-Host "WARNING: This is a vulnerable application for testing only!" -ForegroundColor Yellow
Write-Host "Do not deploy to production environments." -ForegroundColor Red
Write-Host ""
