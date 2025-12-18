output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "aks_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "jumpbox_private_ip" {
  value = azurerm_network_interface.jumpbox_nic.private_ip_address
}

output "bastion_public_ip" {
  value = azurerm_public_ip.bastion_pip.ip_address
}