# Microsoft Defender for Cloud Setup Guide

This guide provides step-by-step instructions to configure Microsoft Defender for Cloud to scan your vulnerable web application using agentless scanning.

## Overview

Microsoft Defender for Cloud provides comprehensive security scanning for:
- ✅ **Code Repositories** (GitHub) - Agentless code scanning
- ✅ **Container Images** (Azure Container Registry) - Vulnerability scanning
- ✅ **Azure Resources** - Configuration and compliance scanning
- ✅ **Infrastructure-as-Code** - Terraform misconfigurations

## Prerequisites

- Azure subscription with active resources
- GitHub repository (https://github.com/jbrotsos/ignite-demo)
- Appropriate Azure permissions (Security Admin or Owner role)
- Resources deployed via Terraform (see TERRAFORM_SETUP.md)

## Part 1: Enable Microsoft Defender for Cloud

### Step 1: Access Defender for Cloud

1. Sign in to the **Azure Portal**: https://portal.azure.com
2. Search for **"Microsoft Defender for Cloud"** in the top search bar
3. Click on **Microsoft Defender for Cloud**

### Step 2: Enable Defender Plans

1. In the left menu, click **Environment settings**
2. Click on your **subscription**
3. You'll see a list of Defender plans

### Step 3: Enable Required Defender Plans

Turn ON the following plans:

| Plan | Purpose | Monthly Cost (Approx) |
|------|---------|---------------------|
| **Defender for Servers** | VM security scanning | $15/server |
| **Defender for App Service** | Web app security | $15/app |
| **Defender for Containers** | Container image scanning | $7/vCore |
| **Defender for Storage** | Storage account scanning | $10/storage account |
| **Defender for SQL** | Database security | $15/server |
| **Defender for Key Vault** | Key vault security | $0.02/10K transactions |
| **Defender CSPM** | Cloud security posture | Free |
| **Defender for DevOps** ⭐ | **GitHub/ADO scanning** | **Free** |

⭐ **Most Important:** Make sure **Defender for DevOps** is enabled!

4. Click **Save** after enabling plans

### Step 4: Configure Settings

For each enabled plan, click **Settings** and ensure:
- Agentless scanning is **enabled**
- Vulnerability assessment is **enabled**
- Auto-provisioning is **enabled** (where applicable)

## Part 2: Connect GitHub Repository

### Step 1: Navigate to DevOps Security

1. In Defender for Cloud, go to **Environment settings**
2. Click **+ Add environment**
3. Select **GitHub**

### Step 2: Authorize GitHub Connection

1. Click **Authorize** to connect to GitHub
2. You'll be redirected to GitHub
3. Sign in to your GitHub account (jbrotsos)
4. Click **Authorize Microsoft-Defender-for-Cloud**
5. Select the repositories you want to scan:
   - ✅ **ignite-demo**
6. Click **Install & Authorize**

### Step 3: Configure DevOps Security

1. Back in Azure Portal, you should see your GitHub organization
2. Click on your organization name
3. Review the connected repositories
4. Ensure **ignite-demo** is listed and scanning is enabled

### Step 4: Configure Scanning Options

1. Click on **ignite-demo** repository
2. Configure scanning settings:
   - ✅ Code scanning (secrets, vulnerabilities)
   - ✅ Dependency scanning
   - ✅ IaC scanning (Terraform)
   - ✅ Container scanning

3. Set scan frequency:
   - **On push** - Recommended
   - **Scheduled** - Daily

## Part 3: Enable Agentless Container Scanning

### Step 1: Configure Container Registry Scanning

1. Go to **Defender for Cloud** → **Environment settings**
2. Click your **subscription**
3. Click **Defender for Containers**
4. Click **Settings**
5. Ensure these are **enabled**:
   - ✅ Agentless container vulnerability assessment
   - ✅ Agentless discovery for Kubernetes
   - ✅ Run-time threat detection

### Step 2: Verify ACR Integration

1. Navigate to **Container Registries** in Azure Portal
2. Click on **acrvulnerableapp**
3. In the left menu, click **Security**
4. Verify Defender for Cloud is connected
5. You should see: "Microsoft Defender for Containers is enabled"

### Step 3: Scan Existing Images

Defender will automatically scan images, but you can trigger a manual scan:

1. In your Container Registry, go to **Repositories**
2. Click on **vulnerable-app**
3. Click on a specific **tag**
4. View **Security findings** tab

## Part 4: Configure Resource Scanning

### Step 1: Enable Security Policy

1. In Defender for Cloud, go to **Regulatory compliance**
2. Ensure these standards are enabled:
   - ✅ **Azure Security Benchmark**
   - ✅ **CIS Microsoft Azure Foundations Benchmark**
   - ✅ **PCI DSS 3.2.1**

### Step 2: Configure Agentless Scanning for VMs (if applicable)

1. Go to **Environment settings** → Your subscription
2. Click **Settings & monitoring**
3. Ensure **Agentless scanning for machines** is **ON**

### Step 3: Configure Continuous Export (Optional)

To export findings to other tools:

1. Go to **Environment settings** → Your subscription
2. Click **Continuous export**
3. Configure export to:
   - Log Analytics workspace
   - Event Hub
   - Storage Account

## Part 5: View Security Findings

### Dashboard Overview

1. Go to **Microsoft Defender for Cloud** home page
2. Review the **Secure Score**
3. View **Recommendations** - should show many issues!

### View Code Scanning Results

1. In Defender for Cloud, click **DevOps security**
2. Click on **ignite-demo** repository
3. View findings:
   - **Secrets** - Hardcoded credentials detected
   - **Vulnerabilities** - Code security issues
   - **IaC issues** - Terraform misconfigurations
   - **Dependencies** - Vulnerable packages

### View Container Scanning Results

1. Go to **Recommendations**
2. Filter by **Container security**
3. Look for findings like:
   - "Container images should have vulnerability findings resolved"
   - "Running container images should have vulnerability findings resolved"
   - "Container registries should have vulnerability assessments enabled"

### View Infrastructure Findings

1. Go to **Recommendations**
2. Look for findings on your resources:
   - **Storage accounts** should encrypt data at rest
   - **SQL servers** should have firewall rules restricted
   - **Network security groups** should not allow unrestricted access
   - **Key vaults** should have purge protection enabled
   - **App Services** should use HTTPS only

### View Compliance Status

1. Click **Regulatory compliance**
2. Select **Azure Security Benchmark**
3. Review compliance score (should be low due to intentional misconfigurations!)
4. Expand categories to see specific failures

## Part 6: Explore Specific Findings

### Expected Security Findings

You should see findings like:

#### Code Security
- ✅ Hardcoded secrets detected (API keys, passwords, AWS credentials)
- ✅ SQL injection vulnerabilities
- ✅ Command injection risks
- ✅ Insecure deserialization
- ✅ Use of eval() and exec()

#### Infrastructure Security
- ✅ Storage accounts with public access
- ✅ SQL firewall allows all IPs (0.0.0.0/0)
- ✅ Network security groups allow SSH/RDP from internet
- ✅ HTTPS not enforced on web apps
- ✅ Weak TLS versions allowed

#### Container Security
- ✅ Base image vulnerabilities (Python 3.8)
- ✅ Container running as root
- ✅ Hardcoded secrets in Dockerfile
- ✅ Vulnerable packages in container

#### IaC Security
- ✅ Terraform files with misconfigurations
- ✅ Missing encryption settings
- ✅ Overly permissive access policies

### Detailed Finding Investigation

1. Click on any **Recommendation**
2. View:
   - **Description** - What the issue is
   - **Severity** - High/Medium/Low
   - **Affected resources** - Which resources have the issue
   - **Remediation steps** - How to fix it
   - **Related resources** - Documentation and references

## Part 7: Configure Alerts and Notifications

### Set Up Email Notifications

1. Go to **Environment settings** → Your subscription
2. Click **Email notifications**
3. Configure:
   - **Email recipients** - Enter your email
   - **Notification types**:
     - ✅ High severity alerts
     - ✅ Moderate severity alerts
     - ✅ Weekly digest
4. Click **Save**

### Configure Security Contacts

1. Still in **Email notifications**
2. Add **Security contact** emails
3. Configure alert preferences:
   - ✅ Alert on new findings
   - ✅ Monthly compliance reports

### Set Up Azure Monitor Alerts (Advanced)

1. Go to **Azure Monitor** in the portal
2. Create **Alert rules** for:
   - New high-severity findings
   - Compliance score drops
   - Critical vulnerabilities detected

## Part 8: Integration with GitHub Advanced Security

### Verify Integration

Defender for Cloud and GitHub Advanced Security work together:

1. **CodeQL** (GitHub) - Detects code vulnerabilities
2. **Defender for DevOps** (Azure) - Aggregates and correlates findings
3. **Secret Scanning** (Both) - Detects hardcoded credentials

### View Unified Results

1. **In GitHub:**
   - Go to https://github.com/jbrotsos/ignite-demo
   - Click **Security** tab
   - View CodeQL and secret scanning results

2. **In Defender for Cloud:**
   - Go to **DevOps security**
   - View aggregated findings from both systems

### Configure GitHub Actions Integration

Defender can trigger actions based on findings:

1. In Defender for Cloud, go to **Workflow automation**
2. Create automation rules:
   - Trigger: New code vulnerability detected
   - Action: Create GitHub issue
   - Action: Send notification

## Part 9: Generate Security Reports

### Download Compliance Reports

1. Go to **Regulatory compliance**
2. Click **Download report**
3. Select format:
   - PDF (for sharing)
   - CSV (for analysis)

### Export Recommendations

1. Go to **Recommendations**
2. Click **Download CSV report**
3. Filter and analyze in Excel

### Create Custom Dashboards

1. Go to **Workbooks** in Defender for Cloud
2. Use templates or create custom workbooks
3. Add widgets for:
   - Secure score trends
   - Top recommendations
   - Resource compliance
   - Container vulnerability trends

## Part 10: Cost Management

### Monitor Defender Costs

1. Go to **Cost Management + Billing**
2. Click **Cost analysis**
3. Filter by:
   - Service: Microsoft Defender for Cloud
   - Resource group: rg-vulnerable-app

### Optimize Costs

For this demo/testing environment:

- **Free tier options:**
  - Defender CSPM - Always free
  - Defender for DevOps - Free
  
- **Paid options to consider:**
  - Enable Defender for Containers only (most findings for this app)
  - Use time-boxed testing (enable/disable as needed)

### Disable Unused Plans

To reduce costs after testing:

1. Go to **Environment settings** → Your subscription
2. Disable plans you don't need
3. Keep **Defender for DevOps** enabled (it's free!)

## Troubleshooting

### Issue: GitHub not connecting

**Solution:**
1. Revoke previous authorizations at https://github.com/settings/applications
2. Try connecting again from Defender for Cloud
3. Ensure you have admin access to the repository

### Issue: No findings showing up

**Solution:**
1. Wait 15-30 minutes after initial setup
2. Trigger a manual scan by pushing a commit to GitHub
3. Verify Defender plans are enabled and not in "trial expired" state

### Issue: Container scanning not working

**Solution:**
1. Ensure Defender for Containers is enabled
2. Push a new image to ACR to trigger scanning
3. Check ACR has "Admin user" enabled (already configured in Terraform)

### Issue: Resource findings not appearing

**Solution:**
1. Verify resources are in a subscription with Defender enabled
2. Check resource group: `rg-vulnerable-app`
3. Wait up to 24 hours for initial resource scan

## Testing the Setup

### Verify Everything is Working

1. **Check GitHub Actions:**
   ```powershell
   # Push a test commit to trigger workflows
   git commit --allow-empty -m "Test Defender scanning"
   git push
   ```

2. **Check CodeQL Results:**
   - Visit: https://github.com/jbrotsos/ignite-demo/security/code-scanning
   - Should see SQL injection, command injection, etc.

3. **Check Defender for DevOps:**
   - In Azure Portal → Defender for Cloud → DevOps security
   - Should see findings from GitHub

4. **Check Container Findings:**
   - After deploying container (via GitHub Actions)
   - In Defender for Cloud → Recommendations
   - Filter by "Container security"

## Expected Timeline

- **Initial setup:** 10-15 minutes
- **First GitHub scan:** 5-10 minutes (CodeQL)
- **First Defender scan:** 15-30 minutes
- **Container image scan:** 5-15 minutes after push
- **Resource compliance scan:** Up to 24 hours

## Next Steps

After setup is complete:

1. ✅ Review all security findings
2. ✅ Compare GitHub Advanced Security vs Defender for Cloud findings
3. ✅ Test remediation workflows
4. ✅ Generate compliance reports
5. ✅ Configure automated responses
6. ✅ Share findings with your team

## Additional Resources

- [Microsoft Defender for Cloud Documentation](https://docs.microsoft.com/azure/defender-for-cloud/)
- [Defender for DevOps](https://docs.microsoft.com/azure/defender-for-cloud/defender-for-devops-introduction)
- [Agentless Scanning](https://docs.microsoft.com/azure/defender-for-cloud/concept-agentless-containers)
- [GitHub Advanced Security](https://docs.github.com/en/code-security)
- [Azure Security Benchmark](https://docs.microsoft.com/security/benchmark/azure/)

## Support

For issues or questions:
- Azure Defender: Azure Support Portal
- GitHub Security: GitHub Support
- General questions: Review the README.md in this repository
