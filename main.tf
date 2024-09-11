resource "azurerm_resource_group" "DEV-RG-01" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "DEV-VNET-01" {
  name                = var.virtual_network_name
  location            = var.location
  tags                = var.tags
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16", ]
  depends_on = [
    azurerm_resource_group.DEV-RG-01
  ]
}

resource "azurerm_subnet" "DEV-Subnet-01" {
  name                 = "DEV-Subnet-01"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.0.0/24"]
  depends_on = [
    azurerm_virtual_network.DEV-VNET-01
  ]
}

resource "azurerm_network_security_group" "DEV-NSG-01" {
  name                = "DEV-NSG-01"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [
    azurerm_subnet.DEV-Subnet-01
  ]
}

resource "azurerm_subnet_network_security_group_association" "Subnet-NSG" {
  subnet_id                 = azurerm_subnet.DEV-Subnet-01.id
  network_security_group_id = azurerm_network_security_group.DEV-NSG-01.id

  depends_on = [
    azurerm_subnet.DEV-Subnet-01,
    azurerm_network_security_group.DEV-NSG-01
  ]
}
