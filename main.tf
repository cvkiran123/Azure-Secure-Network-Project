# 1. Define the Azure Provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  # Prevents 403 errors by skipping automatic registration of unused providers
  skip_provider_registration = true
}

# 2. Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-project"
  location = "East US"
}

# 3. Create the Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-secure-dev"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 4. Create a Budget Alert (FinOps Governance)
resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "budget-monthly-limit"
  resource_group_id = azurerm_resource_group.rg.id
  amount            = 5 
  time_grain        = "Monthly"

  time_period {
    start_date = "2026-06-01T00:00:00Z" 
    end_date   = "2027-06-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 80.0 # Alert when $4 is reached
    operator  = "GreaterThan"
    contact_emails = ["cvkiran4@gmail.com"]
  }
}

# 5. Create a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "snet-internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 6. Create a Network Security Group (The Firewall)
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-secure-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Security: Restricting SSH (Port 22) to internal traffic only
  security_rule {
    name                       = "AllowInternalSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/16" 
    destination_address_prefix = "*"
  }
}

# 7. Link NSG to the Subnet
resource "azurerm_subnet_network_security_group_association" "link" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 8. Create a Public IP (To audit cost impact)
resource "azurerm_public_ip" "pip" {
  name                = "pip-dev-audit"
  resource_group_name  = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 9. Managed Identity for Application
resource "azurerm_user_assigned_identity" "project_identity" {
  name                = "id-secure-vnet-dev"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 10. Enforce Principle of Least Privilege (RBAC Assignment)
resource "azurerm_role_assignment" "reader_access" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Reader" # Least privilege: View-only access
  principal_id         = azurerm_user_assigned_identity.project_identity.principal_id
}