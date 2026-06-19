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
}

# 2. Create a Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-devops-project"
  location = "East US"
}

# 3. Create the Virtual Network (VNet)
resource "azurerm_virtual_network" "vnet" {
  name                = "dev-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 4. Create a Budget Alert (FinOps)
resource "azurerm_consumption_budget_resource_group" "budget" {
  name              = "project-budget"
  resource_group_id = azurerm_resource_group.rg.id
  amount            = 5 # The total amount of money in your currency (e.g., $5)
  time_grain        = "Monthly"

  time_period {
    start_date = "2024-06-01T00:00:00Z" # Must be first of the month
    end_date   = "2025-07-01T00:00:00Z"
  }

  notification {
    enabled   = true
    threshold = 80.0 # Alert when 80% of budget ($4) is reached
    operator  = "GreaterThan"
    contact_emails = [
      "cvkiran4@gmail.com", # Email to receive budget alerts
    ]
  }
}

# 5. Create a Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "internal-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 6. Create a Network Security Group (The Firewall)
resource "azurerm_network_security_group" "nsg" {
  name                = "dev-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # SECURITY MISTAKE: Allowing SSH (Port 22) from the whole internet
  security_rule {
    name                       = "AllowSSH"
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

# 8. Create a Public IP (To see the cost impact)
resource "azurerm_public_ip" "pip" {
  name                = "dev-public-ip"
  resource_group_name  = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}