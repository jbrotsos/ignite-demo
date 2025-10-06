# Vulnerable Web Application for Security Testing

⚠️ **WARNING**: This application contains intentional security vulnerabilities and is designed for security testing purposes only. **DO NOT deploy to production environments.**

## Overview

This project is a deliberately vulnerable web application designed to test agentless code scanning capabilities in:
- **Microsoft Defender for Cloud** (Agentless scanning for code, containers, and infrastructure)
- **GitHub Advanced Security (GHAS)** (CodeQL, Secret Scanning, Dependabot)

The application includes various security vulnerabilities across multiple layers:
- Application code vulnerabilities
- Infrastructure-as-Code (IaC) misconfigurations
- Container security issues
- Hardcoded secrets and credentials
- Dependency vulnerabilities

**Key Features:**
- ✅ Agentless security scanning (no local tools required)
- ✅ Automated GitHub Actions workflows
- ✅ Terraform infrastructure deployment to Azure
- ✅ Real-world vulnerable code patterns
- ✅ Comprehensive documentation

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

Before deploying, you can test the application locally:

#### Run the Application
```bash
python app.py
```
The app will be available at http://localhost:5000

#### Run with Docker Compose
```bash
docker-compose up --build
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

### Quick Start

For detailed step-by-step instructions, see **[DEFENDER_SETUP.md](DEFENDER_SETUP.md)**

### Overview

1. **Enable Defender for Cloud**
   - Sign in to Azure Portal
   - Enable Defender for DevOps (Free)
   - Enable Defender for Containers
   - Enable Defender for App Service

2. **Connect GitHub Repository**
   - In Defender for Cloud, go to Environment settings
   - Add GitHub environment
   - Authorize connection to jbrotsos/ignite-demo
   - Enable agentless scanning

3. **View Findings**
   - Navigate to DevOps security
   - View code vulnerabilities, secrets, IaC issues
   - Check Recommendations for infrastructure findings
   - Review Regulatory compliance dashboard

See **[DEFENDER_SETUP.md](DEFENDER_SETUP.md)** for complete instructions.

## Azure Deployment

### Quick Start

For detailed step-by-step instructions, see **[TERRAFORM_SETUP.md](TERRAFORM_SETUP.md)**

### Prerequisites

- Azure CLI installed
- Terraform 1.0+ installed
- Azure subscription
- Appropriate permissions

### Deploy Infrastructure

1. **Login to Azure**
   ```bash
   az login
   ```

2. **Deploy with Terraform**
   ```bash
   cd terraform
   terraform init
   terraform plan
   terraform apply
   ```

3. **Configure GitHub Secrets**
   
   Create a service principal:
   ```bash
   az ad sp create-for-rbac --name "github-actions-sp" --role contributor --scopes /subscriptions/<subscription-id> --sdk-auth
   ```
   
   Add these secrets to GitHub (**Settings** → **Secrets and variables** → **Actions**):
   - `AZURE_CREDENTIALS` - Service principal JSON output
   - `ACR_USERNAME` - Azure Container Registry admin username  
   - `ACR_PASSWORD` - Azure Container Registry admin password

4. **Deploy Application**
   
   Push code to `main` branch - GitHub Actions will automatically build and deploy

See **[TERRAFORM_SETUP.md](TERRAFORM_SETUP.md)** for complete instructions.

## Security Scanning Workflows

### Automated Scans

The project includes GitHub Actions workflows:

1. **CodeQL Analysis** (`.github/workflows/codeql.yml`)
   - Runs on push, PR, and weekly schedule
   - Detects code vulnerabilities
   - Results appear in GitHub Security tab
   - Part of **GitHub Advanced Security**

2. **Deploy** (`.github/workflows/deploy.yml`)
   - Builds and pushes Docker image to Azure Container Registry
   - Deploys to Azure Web App for Containers
   - Scanned by **Microsoft Defender for Cloud**

### Agentless Security Scanning

This project uses **agentless scanning** provided by:

- **Microsoft Defender for Cloud** - Scans:
  - Code repositories (via GitHub integration)
  - Container images in Azure Container Registry
  - Azure infrastructure resources
  - Terraform IaC configurations
  
- **GitHub Advanced Security** - Provides:
  - CodeQL code scanning
  - Secret scanning
  - Dependency scanning (Dependabot)

**No local security tools required!** All scanning happens automatically in the cloud.

### Manual Scans

You can trigger manual scans:

1. Go to **Actions** tab in GitHub
2. Select the **CodeQL** workflow
3. Click **Run workflow**

For Defender for Cloud scans, push a commit to trigger re-scanning.

## Expected Security Findings

### CodeQL Findings (GitHub Advanced Security)
- SQL injection vulnerabilities
- Command injection vulnerabilities
- Code injection (eval usage)
- Path traversal vulnerabilities
- Insecure deserialization
- XML external entity (XXE) vulnerabilities

### Secret Scanning Findings (GitHub Advanced Security)
- AWS access keys
- API keys
- Database passwords
- Generic secrets

### Defender for Cloud Findings (Agentless Scanning)

#### Code Security
- Hardcoded secrets (API keys, passwords, AWS credentials)
- SQL injection patterns
- Command injection risks
- Insecure deserialization
- Use of eval() and exec()

#### Infrastructure Security
- Public storage access
- Missing encryption
- Open security groups (SSH/RDP from 0.0.0.0/0)
- Weak passwords
- HTTPS not enforced
- Weak TLS versions (TLS 1.0)
- SQL firewall allows all IPs

#### Container Security
- Outdated base images with CVEs
- Vulnerable Python packages
- Container running as root
- Hardcoded secrets in Dockerfile
- Exposed unnecessary ports

#### IaC Security (Terraform)
- Public network access enabled
- Missing encryption settings
- Overly permissive access policies
- Purge protection disabled
- Admin users enabled

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
