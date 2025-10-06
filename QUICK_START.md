# Quick Start Guide

## ✅ What's Been Configured

Your vulnerable web application is now ready for security testing with:

- ✅ **GitHub Repository:** https://github.com/jbrotsos/ignite-demo
- ✅ **GitHub Advanced Security:** Enabled (CodeQL + Secret Scanning)
- ✅ **Agentless Scanning:** Ready for Microsoft Defender for Cloud
- ✅ **Infrastructure-as-Code:** Terraform configurations for Azure
- ✅ **CI/CD Pipeline:** GitHub Actions ready for deployment

## 🚀 Next Steps (In Order)

### 1. Deploy Azure Infrastructure (~15 minutes)

Follow: **[TERRAFORM_SETUP.md](TERRAFORM_SETUP.md)**

```powershell
# Quick commands:
az login
cd terraform
terraform init
terraform apply
```

This creates:
- Resource Group
- Storage Account
- Container Registry (ACR)
- App Service
- SQL Server
- Key Vault
- Network Security Groups
- And more... (all with intentional vulnerabilities!)

### 2. Configure Microsoft Defender for Cloud (~10 minutes)

Follow: **[DEFENDER_SETUP.md](DEFENDER_SETUP.md)**

Key steps:
1. Enable Defender for DevOps (FREE)
2. Connect GitHub repository
3. Enable Defender for Containers
4. Enable agentless scanning
5. View findings in Azure Portal

### 3. Configure GitHub Secrets for Deployment

After Terraform deployment, add these secrets to GitHub:

1. Go to: https://github.com/jbrotsos/ignite-demo/settings/secrets/actions
2. Add:
   - `AZURE_CREDENTIALS` (from service principal)
   - `ACR_USERNAME` (from ACR)
   - `ACR_PASSWORD` (from ACR)

See TERRAFORM_SETUP.md Step 6 for detailed commands.

### 4. Push to Trigger Deployment

```powershell
git commit --allow-empty -m "Trigger deployment"
git push
```

This will:
- Run CodeQL scan (5-10 min)
- Build Docker image
- Push to Azure Container Registry
- Deploy to Azure Web App

### 5. View Security Findings

#### In GitHub (5-10 minutes after push)
- https://github.com/jbrotsos/ignite-demo/security/code-scanning
- View CodeQL findings (SQL injection, command injection, etc.)
- View secret scanning alerts (hardcoded credentials)

#### In Azure Defender for Cloud (15-30 minutes after setup)
- Azure Portal → Microsoft Defender for Cloud
- DevOps Security → View GitHub findings
- Recommendations → View infrastructure findings
- Regulatory Compliance → View compliance score

## 📊 Expected Security Findings

You should see **50+ security issues** including:

### Code Vulnerabilities
- ✅ SQL Injection (multiple instances)
- ✅ Command Injection
- ✅ Code Injection (eval usage)
- ✅ Insecure Deserialization
- ✅ XXE Vulnerabilities
- ✅ Path Traversal

### Hardcoded Secrets
- ✅ AWS Access Keys
- ✅ API Keys
- ✅ Database Passwords
- ✅ Generic Secrets

### Infrastructure Issues
- ✅ Public Storage Access
- ✅ Open Network Security Groups (SSH/RDP from 0.0.0.0/0)
- ✅ Missing Encryption
- ✅ Weak TLS Versions
- ✅ SQL Firewall Open to All IPs
- ✅ HTTPS Not Enforced

### Container Issues
- ✅ Outdated Base Image (Python 3.8)
- ✅ Vulnerable Dependencies
- ✅ Running as Root
- ✅ Hardcoded Secrets in Dockerfile

## 🔍 Testing the Vulnerabilities

### Test Locally
```powershell
# Run the app
python app.py

# Visit http://localhost:5000
# Try vulnerable endpoints:
# - /user/admin' OR '1'='1
# - /calc (POST with expr=__import__('os').system('whoami'))
# - /debug (view secrets)
```

### Test with Docker
```powershell
docker-compose up --build
```

## 📚 Documentation Structure

| File | Purpose |
|------|---------|
| **README.md** | Main project overview and quick reference |
| **TERRAFORM_SETUP.md** | Complete Azure infrastructure deployment guide |
| **DEFENDER_SETUP.md** | Microsoft Defender for Cloud configuration guide |
| **SECURITY.md** | Security policy and responsible use guidelines |
| **Quick_Start.md** | This file - your step-by-step checklist |

## ⚙️ GitHub Actions Workflows

| Workflow | File | Purpose |
|----------|------|---------|
| **CodeQL** | `.github/workflows/codeql.yml` | Code security scanning (GHAS) |
| **Deploy** | `.github/workflows/deploy.yml` | Build & deploy to Azure |

**Note:** Removed Bandit, Checkov, and Trivy workflows - replaced by Defender for Cloud agentless scanning!

## 💰 Cost Considerations

### Free Tier
- ✅ GitHub Advanced Security (may require license)
- ✅ Microsoft Defender for DevOps (FREE)
- ✅ Microsoft Defender CSPM (FREE)

### Paid Azure Services
- **Defender for Containers:** ~$7/vCore/month
- **Defender for App Service:** ~$15/app/month
- **Azure Resources:** ~$10-30/day for this demo

**Tip:** Run `terraform destroy` when not actively testing!

## 🛠️ Troubleshooting

### Issue: CodeQL not running
- **Solution:** Check Actions tab for errors, ensure GHAS is enabled

### Issue: No Defender findings
- **Solution:** Wait 15-30 min after setup, ensure Defender plans are enabled

### Issue: Terraform apply fails
- **Solution:** Check Azure login, verify subscription permissions

### Issue: GitHub Actions deployment fails
- **Solution:** Verify GitHub secrets are configured correctly

## 📞 Getting Help

1. Check the detailed guides:
   - TERRAFORM_SETUP.md (infrastructure issues)
   - DEFENDER_SETUP.md (security scanning issues)
   
2. Review error messages in:
   - GitHub Actions logs
   - Azure Portal Activity Log
   - Terraform output

3. Common solutions:
   - Re-run `az login`
   - Check GitHub secrets
   - Verify Defender plans are enabled

## ✅ Success Checklist

Mark off as you complete:

- [ ] Azure infrastructure deployed via Terraform
- [ ] Service principal created
- [ ] GitHub secrets configured
- [ ] Microsoft Defender for Cloud enabled
- [ ] GitHub connected to Defender
- [ ] Defender plans enabled (DevOps, Containers, App Service)
- [ ] First GitHub Actions deployment successful
- [ ] CodeQL findings visible in GitHub Security tab
- [ ] Defender findings visible in Azure Portal
- [ ] Infrastructure findings visible in Recommendations
- [ ] Container scan results available

## 🎯 Learning Objectives

By completing this setup, you'll learn:

1. ✅ How to deploy vulnerable infrastructure with Terraform
2. ✅ How agentless scanning works (no agents on servers!)
3. ✅ How GitHub Advanced Security detects code vulnerabilities
4. ✅ How Microsoft Defender for Cloud scans containers
5. ✅ How to view and interpret security findings
6. ✅ How to integrate DevOps security into CI/CD pipelines
7. ✅ How to meet compliance requirements (CIS, PCI DSS, etc.)

## 🔐 Important Reminders

⚠️ **This is a vulnerable application by design!**

- DO NOT deploy to production
- DO NOT use real credentials
- DO NOT expose to the public internet (except for demo purposes)
- DO destroy resources when done testing (`terraform destroy`)

## 🌟 What Makes This Special

This project demonstrates:

1. **Agentless Scanning** - No software to install on servers
2. **Multi-Layer Security** - Code, containers, infrastructure, IaC
3. **Cloud-Native** - Designed for Azure and GitHub
4. **Real Vulnerabilities** - Not just test data, actual exploitable issues
5. **Complete Documentation** - Step-by-step guides for everything

---

**Ready to begin?** Start with **Step 1: Deploy Azure Infrastructure** above! 🚀
