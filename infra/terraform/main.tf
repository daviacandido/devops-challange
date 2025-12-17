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

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true

  default_node_pool {
    name       = "system"
    vm_size    = "Standard_D2s_v6"
    node_count = var.system_node_count
    type       = "VirtualMachineScaleSets"
  }

  network_profile {
    network_plugin = "azure"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "usernp"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_node_vm_size
  node_count            = var.user_node_count
  mode                  = "User"
  orchestrator_version  = var.kubernetes_version
}
