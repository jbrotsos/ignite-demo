# Vulnerable Web Application for Security Testing

⚠️ **WARNING**: This application contains intentional security vulnerabilities and is designed for security testing purposes only. **DO NOT deploy to production environments.**

## Overview

This project is a deliberately vulnerable web application designed to test agentless code scanning capabilities in:
- **Microsoft Defender for Cloud**
- **GitHub Advanced Security (GHAS)**

The application includes various security vulnerabilities across multiple layers:
- Application code vulnerabilities
- Infrastructure-as-Code (IaC) misconfigurations
- Container security issues
- Hardcoded secrets and credentials
- Dependency vulnerabilities

## Project Structure

```
.
├── app.py                      # Vulnerable Flask application
├── requirements.txt            # Python dependencies (with known CVEs)
├── Dockerfile                  # Vulnerable container configuration
├── docker-compose.yml          # Local development setup
├── terraform/
│   └── main.tf                # Azure infrastructure with misconfigurations
├── .github/
│   └── workflows/
│       ├── codeql.yml         # CodeQL security scanning
│       ├── security-scan.yml  # Bandit, Checkov, Trivy scanning
│       └── deploy.yml         # Build and deploy to Azure
└── README.md
```

## Intentional Vulnerabilities

### Application Code Vulnerabilities (app.py)

1. **Hardcoded Secrets** - API keys, passwords, and AWS credentials in source code
2. **SQL Injection** - Direct string concatenation in SQL queries
3. **Command Injection** - Unsafe subprocess execution
4. **Insecure Deserialization** - Unsafe pickle.loads() usage
5. **Code Injection** - Use of eval() with user input
6. **Server-Side Template Injection (SSTI)** - Unsafe template rendering
7. **Weak Cryptography** - MD5 hashing for passwords
8. **Information Disclosure** - Debug endpoint exposing sensitive data
9. **Insecure File Upload** - No validation of uploaded files
10. **Missing Authentication** - Admin endpoints without auth checks
11. **Path Traversal** - Direct file access without validation
12. **XXE Vulnerability** - Unsafe XML parsing
13. **Debug Mode in Production** - Flask debug mode enabled

### Infrastructure Vulnerabilities (terraform/main.tf)

1. **Public Storage Access** - Azure Storage with public blob access enabled
2. **Missing Encryption** - Storage accounts without encryption at rest
3. **HTTPS Not Enforced** - HTTP traffic allowed
4. **Open Network Security Groups** - SSH (22), RDP (3389) open to 0.0.0.0/0
5. **Weak Firewall Rules** - SQL Server accessible from all IPs
6. **Admin User Enabled** - Container Registry with admin user enabled
7. **Weak Passwords in Code** - SQL admin password hardcoded
8. **No Network Restrictions** - Key Vault accessible from public internet
9. **Insecure TLS Version** - TLS 1.0 allowed on App Service
10. **Purge Protection Disabled** - Key Vault without purge protection

### Container Vulnerabilities (Dockerfile)

1. **Outdated Base Image** - Python 3.8 with known CVEs
2. **Running as Root** - Container runs with root privileges
3. **Hardcoded Secrets in ENV** - Environment variables with credentials
4. **Exposed Unnecessary Ports** - SSH and MySQL ports exposed
5. **Shell Form CMD** - Vulnerable to shell injection

### Dependency Vulnerabilities (requirements.txt)

- Outdated packages with known CVEs
- PyYAML 5.4.1 (CVE-2020-14343)
- Older Flask and Werkzeug versions

## Setup Instructions

### Prerequisites

- Python 3.8+
- Docker and Docker Compose
- Terraform 1.0+
- Azure CLI
- GitHub account
- Azure subscription

### Local Development Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd serverless-app
   ```

2. **Create a virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the application locally**
   ```bash
   python app.py
   ```
   The app will be available at http://localhost:5000

5. **Run with Docker Compose**
   ```bash
   docker-compose up --build
   ```

### Testing Vulnerabilities Locally

Before deploying, you can test security scanners locally:

#### Bandit (Python Security Linter)
```bash
pip install bandit
bandit -r . -f txt
```

#### Checkov (IaC Scanner)
```bash
pip install checkov
checkov -d . --framework terraform,dockerfile
```

#### Trivy (Container Scanner)
```bash
# Install Trivy first: https://aquasecurity.github.io/trivy/latest/getting-started/installation/
trivy fs .
trivy image <image-name>
```

## GitHub Advanced Security (GHAS) Setup

### 1. Enable GitHub Advanced Security

1. Go to your repository on GitHub
2. Click **Settings** → **Code security and analysis**
3. Enable the following features:
   - **Dependency graph**
   - **Dependabot alerts**
   - **Dependabot security updates**
   - **Code scanning** (CodeQL)
   - **Secret scanning**

### 2. CodeQL Analysis

CodeQL is automatically configured via `.github/workflows/codeql.yml`. It will:
- Run on every push to `main` and `develop` branches
- Run on pull requests
- Run weekly on a schedule
- Detect vulnerabilities like SQL injection, command injection, etc.

### 3. View Security Alerts

1. Go to **Security** tab in your GitHub repository
2. View alerts in:
   - **Code scanning alerts** - CodeQL findings
   - **Secret scanning alerts** - Detected hardcoded secrets
   - **Dependabot alerts** - Vulnerable dependencies

### 4. Secret Scanning

GitHub will automatically detect:
- API keys
- AWS credentials
- Database passwords
- Private keys

## Microsoft Defender for Cloud Setup

### 1. Connect GitHub to Defender for Cloud

1. **Sign in to Azure Portal**
   - Go to https://portal.azure.com

2. **Navigate to Microsoft Defender for Cloud**
   - Search for "Microsoft Defender for Cloud"
   - Click on **Environment settings**

3. **Add GitHub Connector**
   - Click **+ Add environment**
   - Select **GitHub**
   - Click **Authorize** to connect your GitHub account
   - Select the repositories you want to scan

4. **Enable Defender Plans**
   - Enable **Defender for DevOps**
   - Enable **Defender for Containers**
   - Enable **Defender for App Service**

### 2. Configure Agentless Scanning

Defender for Cloud provides agentless scanning for:

#### Code Repositories (GitHub)
- Automatically scans code for vulnerabilities
- Detects secrets and credentials
- Identifies IaC misconfigurations
- No agent installation required

#### Container Images
- Scans images in Azure Container Registry
- Detects vulnerabilities in base images and dependencies
- Runs automatically on push

#### Azure Resources
- Scans deployed infrastructure
- Checks for misconfigurations
- Monitors compliance with security benchmarks

### 3. View Findings in Defender for Cloud

1. **Navigate to Recommendations**
   - Go to **Defender for Cloud** → **Recommendations**
   - Filter by resource type or severity

2. **Review Code Vulnerabilities**
   - Look for findings from GitHub repositories
   - Review SQL injection, command injection alerts
   - Check for hardcoded secrets

3. **Review IaC Misconfigurations**
   - Check Terraform findings
   - Review network security group rules
   - Validate encryption settings

4. **Review Container Vulnerabilities**
   - Check Docker image scan results
   - Review base image vulnerabilities
   - Check for malware

### 4. Secure Score

- Navigate to **Secure Score** in Defender for Cloud
- Review security posture
- Implement recommended remediation steps

## Azure Deployment

### 1. Configure Azure Resources

1. **Login to Azure**
   ```bash
   az login
   ```

2. **Create Service Principal**
   ```bash
   az ad sp create-for-rbac --name "github-actions-sp" \
     --role contributor \
     --scopes /subscriptions/<subscription-id> \
     --sdk-auth
   ```

3. **Deploy Infrastructure with Terraform**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

### 2. Configure GitHub Secrets

Add the following secrets to your GitHub repository (**Settings** → **Secrets and variables** → **Actions**):

- `AZURE_CREDENTIALS` - Output from service principal creation
- `ACR_USERNAME` - Azure Container Registry admin username
- `ACR_PASSWORD` - Azure Container Registry admin password

### 3. Deploy Application

1. Push code to `main` branch
2. GitHub Actions will automatically:
   - Build Docker image
   - Push to Azure Container Registry
   - Deploy to Azure Web App for Containers

### 4. Monitor Deployment

- Check GitHub Actions for deployment status
- View application at: `https://<webapp-name>.azurewebsites.net`

## Security Scanning Workflows

### Automated Scans

The project includes three GitHub Actions workflows:

1. **CodeQL Analysis** (`.github/workflows/codeql.yml`)
   - Runs on push, PR, and weekly schedule
   - Detects code vulnerabilities
   - Results appear in GitHub Security tab

2. **Security Scanning** (`.github/workflows/security-scan.yml`)
   - **Bandit** - Python security linter
   - **Checkov** - IaC security scanner
   - **Trivy** - Dependency and container scanner
   - **TruffleHog** - Secret detection

3. **Deploy** (`.github/workflows/deploy.yml`)
   - Builds and pushes Docker image
   - Scans container image
   - Deploys to Azure

### Manual Scans

You can trigger manual scans:

1. Go to **Actions** tab in GitHub
2. Select the workflow
3. Click **Run workflow**

## Expected Security Findings

### CodeQL Findings
- SQL injection vulnerabilities
- Command injection vulnerabilities
- Code injection (eval usage)
- Path traversal vulnerabilities
- Insecure deserialization
- XML external entity (XXE) vulnerabilities

### Bandit Findings
- Hardcoded passwords (B105, B106)
- Use of pickle (B301)
- Use of MD5 (B324)
- SQL injection (B608)
- Shell injection (B602, B607)

### Checkov Findings
- Public storage access
- Missing encryption
- Open security groups
- Weak passwords
- HTTPS not enforced
- Public network access enabled

### Trivy Findings
- Outdated base images
- Vulnerable Python packages
- Known CVEs in dependencies

### Secret Scanning Findings
- AWS access keys
- API keys
- Database passwords
- Generic secrets

## Remediation Examples

### Fix SQL Injection
```python
# Vulnerable
query = f"SELECT * FROM users WHERE username = '{username}'"

# Fixed
query = "SELECT * FROM users WHERE username = ?"
cursor.execute(query, (username,))
```

### Fix Hardcoded Secrets
```python
# Vulnerable
API_KEY = "sk-1234567890abcdef"

# Fixed
API_KEY = os.environ.get('API_KEY')
```

### Fix Terraform Network Security
```hcl
# Vulnerable
source_address_prefix = "*"

# Fixed
source_address_prefix = "10.0.0.0/8"  # Restrict to specific CIDR
```

### Fix Dockerfile
```dockerfile
# Vulnerable
FROM python:3.8

# Fixed
FROM python:3.11-slim

# Add non-root user
RUN useradd -m appuser
USER appuser
```

## Learning Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GitHub Advanced Security Documentation](https://docs.github.com/en/code-security)
- [Microsoft Defender for Cloud Documentation](https://docs.microsoft.com/azure/defender-for-cloud/)
- [Azure Security Best Practices](https://docs.microsoft.com/azure/security/fundamentals/best-practices-and-patterns)
- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks/)

## Contributing

This is a demonstration project. Feel free to:
- Add more vulnerability examples
- Improve documentation
- Add additional security scanners
- Create remediation guides

## License

This project is for educational purposes only.

## Disclaimer

⚠️ **IMPORTANT**: This application is intentionally vulnerable and should NEVER be deployed to production. Use only in isolated, controlled environments for security testing and training purposes.
