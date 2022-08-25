resource "azurerm_network_interface" "vm_nic_resources" {
  name                = "vm-nic-resources"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet_33.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "aks_vm_01" {
  name                = "akstfvm01"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  size                = "Standard_D4s_v3"
  admin_username      = ""
  admin_password      = ""
  network_interface_ids = [
    azurerm_network_interface.vm_nic_resources.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "Windows-10"
    sku       = "win10-21h2-pro-g2"
    version   = "latest"
  }
}
