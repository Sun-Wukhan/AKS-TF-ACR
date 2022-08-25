# resource "azurerm_nat_gateway" "this" {

#   name = "aks-shared-natgw"
#   location                = azurerm_resource_group.aks.location
#   resource_group_name     = azurerm_resource_group.aks.name
#   sku_name                = "Standard"
#   idle_timeout_in_minutes = 10
#   zones                   = []
# }

# resource "azurerm_public_ip" "pip" {

#   name = "aks-pip"
#   resource_group_name = azurerm_resource_group.aks.name
#   location = azurerm_resource_group.aks.location
  
#   allocation_method = "Static"
#   sku               = "Standard"
  
#   availability_zone = "No-Zone"
  
# }

# resource "azurerm_nat_gateway_public_ip_association" "natgw" {

#   nat_gateway_id       = azurerm_nat_gateway.this.id
#   public_ip_address_id = azurerm_public_ip.pip.id
# }

# resource "azurerm_subnet_nat_gateway_association" "subnet_1" {

#   subnet_id      = azurerm_subnet.subnet_1.id
#   nat_gateway_id = azurerm_nat_gateway.this.id
# }