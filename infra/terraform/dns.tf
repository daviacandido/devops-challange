resource "azurerm_dns_zone" "public" {
  name                = var.dns_zone_name
  resource_group_name = azurerm_resource_group.rg.name
}

output "dns_zone_name_servers" {
  description = "Name servers to configure"
  value       = azurerm_dns_zone.public.name_servers
}