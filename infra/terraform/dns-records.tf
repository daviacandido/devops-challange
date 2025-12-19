locals {
  create_bry_record = length(trimspace(var.bry_ingress_public_ip)) > 0
}

resource "cloudflare_dns_record" "bry" {
  count = local.create_bry_record ? 1 : 0

  zone_id = var.cloudflare_zone_id
  name    = "bry"
  type    = "A"
  content = var.bry_ingress_public_ip

  proxied = true
  ttl     = 1 # auto
}