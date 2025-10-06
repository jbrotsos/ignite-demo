terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# VULNERABILITY 1: Resource group without tags
resource "azurerm_resource_group" "main" {
  name     = "rg-vulnerable-app"
  location = "East US"
}

# VULNERABILITY 2: Storage account without encryption
resource "azurerm_storage_account" "main" {
  name                     = "stgvulnerableapp"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  # VULNERABILITY: Public access enabled
  allow_blob_public_access = true
  
  # VULNERABILITY: No encryption at rest
  # encryption is disabled
  
  # VULNERABILITY: HTTPS not enforced
  enable_https_traffic_only = false
  
  # VULNERABILITY: No network rules
  network_rules {
    default_action = "Allow"
  }
}

# VULNERABILITY 3: Container with public access
resource "azurerm_storage_container" "main" {
  name                  = "vulnerable-container"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"  # VULNERABILITY: Public blob access
}

# VULNERABILITY 4: Virtual Network with overly permissive rules
resource "azurerm_virtual_network" "main" {
  name                = "vnet-vulnerable"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-vulnerable"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# VULNERABILITY 5: Network Security Group with open ports
resource "azurerm_network_security_group" "main" {
  name                = "nsg-vulnerable"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  # VULNERABILITY: Allow SSH from anywhere
  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"  # VULNERABILITY: Open to the world
    destination_address_prefix = "*"
  }

  # VULNERABILITY: Allow RDP from anywhere
  security_rule {
    name                       = "AllowRDP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"  # VULNERABILITY: Open to the world
    destination_address_prefix = "*"
  }

  # VULNERABILITY: Allow all outbound traffic
  security_rule {
    name                       = "AllowAllOutbound"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# VULNERABILITY 6: Container Registry without admin disabled
resource "azurerm_container_registry" "main" {
  name                = "acrvulnerableapp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku                 = "Basic"
  
  # VULNERABILITY: Admin user enabled
  admin_enabled = true
  
  # VULNERABILITY: No network restrictions
  public_network_access_enabled = true
}

# VULNERABILITY 7: App Service Plan
resource "azurerm_service_plan" "main" {
  name                = "asp-vulnerable"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  os_type             = "Linux"
  sku_name            = "B1"
}

# VULNERABILITY 8: App Service without HTTPS only
resource "azurerm_linux_web_app" "main" {
  name                = "app-vulnerable-webapp"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_service_plan.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      docker_image     = "${azurerm_container_registry.main.login_server}/vulnerable-app"
      docker_image_tag = "latest"
    }
    
    # VULNERABILITY: Insecure minimum TLS version
    minimum_tls_version = "1.0"
  }

  app_settings = {
    # VULNERABILITY: Hardcoded secrets in app settings
    "API_KEY"           = "sk-1234567890abcdef"
    "DB_PASSWORD"       = "SuperSecretPassword123!"
    "WEBSITES_PORT"     = "5000"
  }

  # VULNERABILITY: HTTPS not enforced
  https_only = false

  identity {
    type = "SystemAssigned"
  }
}

# VULNERABILITY 9: Key Vault without proper access policies
resource "azurerm_key_vault" "main" {
  name                        = "kv-vulnerable-app"
  location                    = azurerm_resource_group.main.location
  resource_group_name         = azurerm_resource_group.main.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false  # VULNERABILITY: Purge protection disabled
  sku_name                    = "standard"

  # VULNERABILITY: Public network access enabled
  public_network_access_enabled = true
  
  # VULNERABILITY: No network ACLs
  network_acls {
    bypass         = "AzureServices"
    default_action = "Allow"  # VULNERABILITY: Allow all by default
  }
}

data "azurerm_client_config" "current" {}

# VULNERABILITY 10: SQL Database without encryption
resource "azurerm_mssql_server" "main" {
  name                         = "sql-vulnerable-app"
  resource_group_name          = azurerm_resource_group.main.name
  location                     = azurerm_resource_group.main.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "P@ssw0rd1234!"  # VULNERABILITY: Weak password in code
  
  # VULNERABILITY: Public network access enabled
  public_network_access_enabled = true
}

resource "azurerm_mssql_firewall_rule" "main" {
  name             = "AllowAll"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"  # VULNERABILITY: Allow all IPs
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_mssql_database" "main" {
  name           = "vulnerable-db"
  server_id      = azurerm_mssql_server.main.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"
  
  # VULNERABILITY: Transparent Data Encryption not explicitly enabled
}

output "acr_login_server" {
  value = azurerm_container_registry.main.login_server
}

output "web_app_url" {
  value = azurerm_linux_web_app.main.default_hostname
}
