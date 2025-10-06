# VULNERABILITY: Using an outdated base image with known CVEs
FROM python:3.8

# VULNERABILITY: Running as root user
WORKDIR /app

# VULNERABILITY: Hardcoded secrets in environment variables
ENV API_KEY="sk-prod-1234567890"
ENV DATABASE_URL="postgresql://admin:password123@db:5432/mydb"

# Copy application files
COPY requirements.txt .
COPY app.py .

# VULNERABILITY: Installing packages without pinning versions
RUN pip install --no-cache-dir -r requirements.txt

# VULNERABILITY: Exposing unnecessary ports
EXPOSE 5000
EXPOSE 22
EXPOSE 3306

# VULNERABILITY: Using shell form of CMD (allows shell injection)
CMD python app.py
