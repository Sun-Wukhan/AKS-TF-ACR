resource "azurerm_kubernetes_cluster" "this" {
  name                    = "aks-tf"
  location                = azurerm_resource_group.aks.location
  kubernetes_version      = "1.23.5"
  resource_group_name     = azurerm_resource_group.aks.name
  dns_prefix              = "aks-tf"
  private_cluster_enabled = true
  role_based_access_control_enabled = true

  default_node_pool {
    #availability_zones           = []
    enable_auto_scaling          = true
    enable_host_encryption       = false
    enable_node_public_ip        = false
    fips_enabled                 = false
    kubelet_disk_type            = "OS"
    max_count                    = 3
    max_pods                     = 110
    min_count                    = 1
    name                         = "agentpool"
    node_labels                  = {}
    node_taints                  = []
    only_critical_addons_enabled = false
    orchestrator_version         = "1.23.5"
    os_disk_size_gb              = 128
    os_sku                       = "Ubuntu"
    vm_size                      = "Standard_D4s_v3"
    vnet_subnet_id = azurerm_subnet.subnet_1.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.0.0.10"
    network_plugin     = "azure"
    #outbound_type      = "loadBalancer"
    service_cidr       = "10.0.0.0/16"
  }
}
