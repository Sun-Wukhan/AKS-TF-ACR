resource "azurerm_storage_account" "this" {
  name                     = "testingstorageaks"
  resource_group_name       = azurerm_resource_group.aks.name
  location                  = azurerm_resource_group.aks.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "LRS"

    network_rules {
    default_action             = "Deny"
  }
}

resource "azurerm_storage_container" "container_1" {
  name                  = "public1"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_2" {
  name                  = "public2"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_3" {
  name                  = "private"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_4" {
  name                  = "private4"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_5" {
  name                  = "private5"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_6" {
  name                  = "private6"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_7" {
  name                  = "private7"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_8" {
  name                  = "private8"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "container_9" {
  name                  = "private9"
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}

# resource "azurerm_storage_container" "container_10" {
#   name                  = "private10"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_container" "container_11" {
#   name                  = "private11"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_container" "container_12" {
#   name                  = "private12"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_container" "container_13" {
#   name                  = "private13"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_container" "container_14" {
#   name                  = "private14"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_container" "container_15" {
#   name                  = "private15"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"
# }

# resource "azurerm_storage_container" "container_16" {
#   name                  = "private16"
#   storage_account_name  = azurerm_storage_account.this.name
#   container_access_type = "private"
# }

resource "azurerm_private_dns_zone" "storage_dns" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "storage_links" {
  name                  = "storage-link-to-resource-vnet"
  resource_group_name   = azurerm_resource_group.aks.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_dns.name
  virtual_network_id  = azurerm_virtual_network.resources_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "to_aks_vnet" {
  name                  = "storage-link-to-aks-vnet"
  resource_group_name   = azurerm_resource_group.aks.name
  private_dns_zone_name = azurerm_private_dns_zone.storage_dns.name
  virtual_network_id  = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "storage_endpoint" {
  name                = "storage-blob-pe"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  subnet_id           = azurerm_subnet.subnet_5.id

  private_service_connection  {
    name                           = "storageblob-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_storage_account.this.id
    subresource_names              = ["blob"]
  }
}

resource "azurerm_private_dns_a_record" "storage_a_record" {
  name                = azurerm_storage_account.this.name
  zone_name           = azurerm_private_dns_zone.storage_dns.name
  resource_group_name = azurerm_resource_group.aks.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.storage_endpoint.private_service_connection.0.private_ip_address]
}