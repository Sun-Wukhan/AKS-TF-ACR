resource "azurerm_public_ip" "bas_ip" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "akstfbastion"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.subnet_4.id
    public_ip_address_id = azurerm_public_ip.bas_ip.id
  }
}