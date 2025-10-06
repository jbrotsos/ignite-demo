# Terraform Azure Setup Guide

This guide will help you deploy the vulnerable web application infrastructure to Azure using Terraform.

## Prerequisites

- Azure CLI installed and configured
- Terraform 1.0+ installed
- An active Azure subscription
- Appropriate permissions to create resources in Azure

## Step 1: Install Required Tools

### Install Azure CLI (if not already installed)

**Windows (PowerShell):**
```powershell
winget install -e --id Microsoft.AzureCLI
```

**Or download from:** https://aka.ms/installazurecliwindows

### Install Terraform (if not already installed)

**Windows (PowerShell):**
```powershell
winget install -e --id Hashicorp.Terraform
```

**Or download from:** https://www.terraform.io/downloads

## Step 2: Login to Azure

```powershell
az login
```

This will open a browser window for you to authenticate. After successful login, you'll see your subscription details.

### Set Your Default Subscription (if you have multiple)

```powershell
# List your subscriptions
az account list --output table

# Set the subscription you want to use
az account set --subscription "<subscription-id-or-name>"
```

## Step 3: Initialize Terraform

Navigate to the terraform directory and initialize:

```powershell
cd terraform
terraform init
```

This will download the required Azure provider plugins.

## Step 4: Review the Terraform Plan

Before applying, review what resources will be created:

```powershell
terraform plan
```

### Expected Resources to be Created:

1. **Resource Group** - Container for all resources
2. **Storage Account** - With intentional misconfigurations
3. **Virtual Network & Subnet** - Network infrastructure
4. **Network Security Group** - With overly permissive rules
5. **Container Registry** - For Docker images
6. **App Service Plan** - Linux-based hosting
7. **Web App** - Container-based web application
8. **Key Vault** - With security misconfigurations
9. **SQL Server & Database** - With weak security settings

⚠️ **Note:** These resources contain intentional security misconfigurations for testing purposes.

## Step 5: Apply Terraform Configuration

Deploy the infrastructure:

```powershell
terraform apply
```

Type `yes` when prompted to confirm.

**Deployment time:** Approximately 5-10 minutes.

### Important Outputs

After successful deployment, Terraform will output:
- **ACR Login Server** - Your Azure Container Registry URL
- **Web App URL** - Your application endpoint

Save these values for later use!

## Step 6: Configure GitHub Secrets for CI/CD

To enable automated deployments, you need to set up GitHub secrets.

### Create Azure Service Principal

```powershell
# Get your subscription ID
$subscriptionId = az account show --query id -o tsv

# Create service principal with Contributor role
az ad sp create-for-rbac `
  --name "github-actions-ignite-demo" `
  --role contributor `
  --scopes /subscriptions/$subscriptionId `
  --sdk-auth
```

**Copy the entire JSON output** - you'll need it for GitHub secrets!

### Get ACR Credentials

```powershell
# Get ACR admin credentials
az acr credential show --name acrvulnerableapp --resource-group rg-vulnerable-app
```

Copy the **username** and **password** values.

### Add Secrets to GitHub

1. Go to your GitHub repository: https://github.com/jbrotsos/ignite-demo
2. Click **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**
4. Add these secrets:

| Secret Name | Value |
|-------------|-------|
| `AZURE_CREDENTIALS` | The entire JSON output from the service principal creation |
| `ACR_USERNAME` | The ACR admin username |
| `ACR_PASSWORD` | The ACR admin password |

## Step 7: Verify Deployment

### Check Resource Group

```powershell
az group show --name rg-vulnerable-app
```

### List All Resources

```powershell
az resource list --resource-group rg-vulnerable-app --output table
```

### Test Web App Endpoint

```powershell
# Get the web app URL
$webAppUrl = terraform output -raw web_app_url
Write-Host "Web App URL: https://$webAppUrl"
```

## Step 8: Connect to Microsoft Defender for Cloud

After deploying resources, configure Defender for Cloud to scan them.

See **DEFENDER_SETUP.md** for detailed instructions.

## Managing Your Infrastructure

### View Current State

```powershell
terraform show
```

### Update Resources

After modifying `main.tf`:

```powershell
terraform plan
terraform apply
```

### Destroy All Resources

When you're done testing and want to clean up:

```powershell
terraform destroy
```

Type `yes` to confirm deletion of all resources.

⚠️ **Warning:** This will permanently delete all resources. Make sure you've backed up any data you need!

## Troubleshooting

### Issue: "Authorization failed"

**Solution:** Ensure you're logged in and have the correct subscription selected:
```powershell
az login
az account set --subscription "<your-subscription-id>"
```

### Issue: "Resource name already exists"

**Solution:** Resource names in Azure must be globally unique. Edit `terraform/main.tf` and modify:
- `acrvulnerableapp` → `acr<yourname>vulnapp`
- `stgvulnerableapp` → `stg<yourname>vulnapp`
- `app-vulnerable-webapp` → `app-<yourname>-vulnapp`

### Issue: Terraform state is locked

**Solution:** If a previous operation was interrupted:
```powershell
terraform force-unlock <lock-id>
```

### Issue: Insufficient permissions

**Solution:** You need at least **Contributor** role on the subscription. Contact your Azure administrator.

## Cost Estimation

Running this infrastructure will incur Azure costs:

- **Basic tier resources:** ~$10-30/day
- **Storage:** ~$1-5/month
- **Data transfer:** Varies by usage

💡 **Tip:** Remember to run `terraform destroy` when not actively testing to avoid charges!

## Security Considerations

⚠️ **This infrastructure contains intentional security misconfigurations:**

- Public network access enabled
- Weak firewall rules
- Missing encryption settings
- Exposed storage containers
- Admin accounts enabled

**DO NOT use this for production workloads!**

These misconfigurations are designed to be detected by:
- Microsoft Defender for Cloud
- Azure Security Center
- Compliance scanning tools

## Next Steps

After deploying infrastructure:

1. ✅ Configure Microsoft Defender for Cloud (see DEFENDER_SETUP.md)
2. ✅ Push code to trigger GitHub Actions deployment
3. ✅ Review security findings in Defender for Cloud
4. ✅ Test agentless scanning capabilities
5. ✅ Review CodeQL findings in GitHub Security tab

## Additional Resources

- [Azure CLI Documentation](https://docs.microsoft.com/cli/azure/)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Security Best Practices](https://docs.microsoft.com/azure/security/fundamentals/best-practices-and-patterns)
