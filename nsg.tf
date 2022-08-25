# resource "azurerm_network_security_group" "this" {
#   name                = "aks-vm-nsg"
#   location            = azurerm_resource_group.aks.location
#   resource_group_name = azurerm_resource_group.aks.name

#   security_rule {
#     name                                       = "Terraform-Agent"
#     access                                     = "Allow"
#     description                                = ""
#     destination_address_prefix                 = "*"
#     destination_address_prefixes               = []
#     destination_application_security_group_ids = []
#     destination_port_range                     = "*"
#     destination_port_ranges                    = []
#     direction                                  = "Inbound"    
#     priority                                   = 100
#     protocol                                   = "*"
#     source_address_prefix                      = "8.8.8.8"
#     source_address_prefixes                    = []
#     source_application_security_group_ids      = []
#     source_port_range                          = "*"
#     source_port_ranges                         = []
#   }
# }