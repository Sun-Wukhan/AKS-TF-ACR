resource "azurerm_container_registry" "this" {
  name                = "acrtf"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "Premium"
  admin_enabled       = true
  public_network_access_enabled = false

#   network_rule_set = [ {
#     default_action = "deny"
#     ip_rule = [ {
#       action = "allow"
#       ip_range = "8.8.8.8/32"
#     } ]
#     virtual_network = [ {
#       action = "value"
#       subnet_id = "value"
#     } ]
#   } ]
}

resource "azurerm_private_dns_zone" "acr_dns" {
  name                = "privatelink.azurecr.io"
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_to_acr" {
  name                  = "acr-to-acr-vnet"
  resource_group_name   = azurerm_resource_group.aks.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = azurerm_virtual_network.acr_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_to_aks" {
  name                  = "acr-to-aks-vnet"
  resource_group_name   = azurerm_resource_group.aks.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "acr_to_resources" {
  name                  = "acr-to-resources-vnet"
  resource_group_name   = azurerm_resource_group.aks.name
  private_dns_zone_name = azurerm_private_dns_zone.acr_dns.name
  virtual_network_id    = azurerm_virtual_network.resources_vnet.id
}

resource "azurerm_private_endpoint" "this" {
  name                = "acr-private-endpoint"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  subnet_id           = azurerm_subnet.subnet_02.id

  private_service_connection  {
    name                           = "acr-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.this.id
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name =  "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.acr_dns.id]
  }
}