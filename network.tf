resource "azurerm_virtual_network" "vnet" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["10.0.0.0/8"]
  
}

resource "azurerm_virtual_network" "resources_vnet" {
  name                = "resources-vnet"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["20.0.0.0/16"]
  
}

resource "azurerm_virtual_network" "acr_vnet" {
  name                = "acr-vnet"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  address_space       = ["30.0.0.0/16"]  
}

resource "azurerm_virtual_network_peering" "vnet_to" {
  name                      = "aks-to-resources"
  resource_group_name       = azurerm_resource_group.aks.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.resources_vnet.id
}

resource "azurerm_virtual_network_peering" "resources_to" {
  name                      = "resources-to-aks"
  resource_group_name       = azurerm_resource_group.aks.name
  virtual_network_name      = azurerm_virtual_network.resources_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "acr_to_aks" {
  name                      = "acr-to-aks"
  resource_group_name       = azurerm_resource_group.aks.name
  virtual_network_name      = azurerm_virtual_network.acr_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.vnet.id
}

resource "azurerm_virtual_network_peering" "aks_to_acr" {
  name                      = "aks-to-acr"
  resource_group_name       = azurerm_resource_group.aks.name
  virtual_network_name      = azurerm_virtual_network.vnet.name
  remote_virtual_network_id = azurerm_virtual_network.acr_vnet.id
}

###Juan Test###
resource "azurerm_virtual_network_peering" "acr_to_resources" {
  name                      = "acr-to-resources"
  resource_group_name       = azurerm_resource_group.aks.name
  virtual_network_name      = azurerm_virtual_network.acr_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.resources_vnet.id
}

resource "azurerm_virtual_network_peering" "resources_to_acr" {
  name                      = "resources-to-acr"
  resource_group_name       = azurerm_resource_group.aks.name
  virtual_network_name      = azurerm_virtual_network.resources_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.acr_vnet.id
}

resource "azurerm_subnet" "subnet_1" {
  name                 = "aks"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.240.0.0/16"]
}

resource "azurerm_subnet" "subnet_02" {
  name                 = "acr"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.acr_vnet.name
  address_prefixes       = ["30.0.0.0/24"]
  enforce_private_link_endpoint_network_policies  = true
}


# resource "azurerm_subnet_network_security_group_association" "subnet_2" {
#   subnet_id                 = azurerm_subnet.subnet_2.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

# resource "azurerm_subnet" "subnet_3" {
#   name                 = "vm"
#   resource_group_name  = azurerm_resource_group.aks.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes       = ["10.0.1.0/24"]
# }

resource "azurerm_subnet" "subnet_33" {
  name                 = "vm"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.resources_vnet.name
  address_prefixes       = ["20.0.1.0/24"]
}

# resource "azurerm_subnet_network_security_group_association" "subnet_3" {
#   subnet_id                 = azurerm_subnet.subnet_3.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }

resource "azurerm_subnet" "subnet_4" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.resources_vnet.name
  address_prefixes       = ["20.0.2.0/26"]
}

# resource "azurerm_subnet" "subnet_bast" {
#   name                 = "AzureBastionSubnet"
#   resource_group_name  = azurerm_resource_group.aks.name
#   virtual_network_name = azurerm_virtual_network.vnet.name
#   address_prefixes       = ["10.0.2.0/26"]
# }

resource "azurerm_subnet" "subnet_5" {
  name                 = "private-endpoints"
  resource_group_name  = azurerm_resource_group.aks.name
  virtual_network_name = azurerm_virtual_network.resources_vnet.name
  address_prefixes       = ["20.0.3.0/24"]
  enforce_private_link_endpoint_network_policies  = true
}

# resource "azurerm_subnet_network_security_group_association" "subnet_5" {
#   subnet_id                 = azurerm_subnet.subnet_5.id
#   network_security_group_id = azurerm_network_security_group.this.id
# }