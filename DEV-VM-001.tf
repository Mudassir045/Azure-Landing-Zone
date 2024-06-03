
resource "azurerm_network_interface" "DEV-VM-001-nic" {
  name                = "DEV-VM-001-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.DEV-Subnet-01.id
    private_ip_address_allocation = "Dynamic"
  }
  depends_on = [azurerm_subnet.DEV-Subnet-01]
}

resource "azurerm_windows_virtual_machine" "DEV-VM-001" {
  name                = "DEV-VM-001"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_F2"
  tags                = var.tags
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.DEV-VM-001-nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
  depends_on = [azurerm_network_interface.DEV-VM-001-nic,
  azurerm_resource_group.DEV-RG-01]
}
