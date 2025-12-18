resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix

  kubernetes_version = var.kubernetes_version

  # ✅ AKS PRIVATE
  private_cluster_enabled = true

  # ✅ mais simples pro desafio (DNS gerenciado pelo AKS)
  private_dns_zone_id = "System"

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  default_node_pool {
    name       = "system"
    vm_size    = "Standard_D2s_v6"
    node_count = var.system_node_count
    type       = "VirtualMachineScaleSets"

    # ✅ coloca o AKS na subnet
    vnet_subnet_id = azurerm_subnet.snet_aks.id
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "usernp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_node_vm_size
  node_count            = var.user_node_count
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version

  # ✅ user pool também na subnet do AKS
  vnet_subnet_id = azurerm_subnet.snet_aks.id
}
