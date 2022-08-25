resource "azurerm_key_vault" "aks" {
  name                        = "devops-vault-aks"
  location                    = azurerm_resource_group.aks.location
  resource_group_name         = azurerm_resource_group.aks.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name = "standard"

    network_acls {
    default_action             = "Deny"
    bypass = "AzureServices"
  }
}

resource "azurerm_private_dns_zone" "keyvault_dns" {
  name                = "privatelink.vaultcore.azure.net"
  resource_group_name = azurerm_resource_group.aks.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_to_resources" {
  name                  = "vault-to-resources-vnet"
  resource_group_name   = azurerm_resource_group.aks.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault_dns.name
  virtual_network_id  = azurerm_virtual_network.resources_vnet.id
}

resource "azurerm_private_dns_zone_virtual_network_link" "link_to_aks" {
  name                  = "vault-to-aks-vnet"
  resource_group_name   = azurerm_resource_group.aks.name
  private_dns_zone_name = azurerm_private_dns_zone.keyvault_dns.name
  virtual_network_id  = azurerm_virtual_network.vnet.id
}

resource "azurerm_private_endpoint" "keyvault_endpoint" {
  name                = "keyvault-private-endpoint"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  subnet_id           = azurerm_subnet.subnet_5.id

  private_service_connection  {
    name                           = "keyvault-psc"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.aks.id
    subresource_names              = ["vault"]
  }
}

resource "azurerm_private_dns_a_record" "keyvault_a_record" {
  name                = azurerm_key_vault.aks.name
  zone_name           = azurerm_private_dns_zone.keyvault_dns.name
  resource_group_name = azurerm_resource_group.aks.name
  ttl                 = 300
  records             = [azurerm_private_endpoint.keyvault_endpoint.private_service_connection.0.private_ip_address]
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "vm-password"
  value        = var.vm_password
  key_vault_id = azurerm_key_vault.aks.id
}

resource "azurerm_key_vault_secret" "test_01" {
  name         = "test-01"
  value        = "test-01"
  key_vault_id = azurerm_key_vault.aks.id
}

resource "azurerm_key_vault_secret" "test_02" {
  name         = "test-02"
  value        = "test-02"
  key_vault_id = azurerm_key_vault.aks.id
}

# resource "azurerm_key_vault_secret" "test_01" {
#   name         = "vm-password"
#   value        = var.vm_password
#   key_vault_id = azurerm_key_vault.aks.id
# }