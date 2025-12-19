locals {
  create_bry_record = length(trimspace(var.bry_ingress_public_ip)) > 0
}

resource "azurerm_dns_a_record" "bry" {
  count               = local.create_bry_record ? 1 : 0

  name                = "bry"
  zone_name           = azurerm_dns_zone.public.name
  resource_group_name = azurerm_resource_group.rg.name

  ttl     = 60
  records = [var.bry_ingress_public_ip]
}