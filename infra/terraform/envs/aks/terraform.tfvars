location            = "Brazil South"
resource_group_name = "rg-aks-poc-bry"

aks_name   = "aks-poc-bry"
dns_prefix = "poc-bry"

kubernetes_version = null

system_node_count = 1
user_node_count   = 2
user_node_vm_size = "Standard_D2s_v6"

vnet_name = "vnet-aks-poc-bry"
vnet_cidr = "10.10.0.0/16"

aks_subnet_name = "snet-aks"
aks_subnet_cidr = "10.10.1.0/24"

jumpbox_subnet_name = "snet-jumpbox"
jumpbox_subnet_cidr = "10.10.2.0/24"

bastion_subnet_cidr = "10.10.3.0/27"

bastion_name = "bst-aks-poc-bry"

jumpbox_name           = "vm-jumpbox-aks-poc-bry"
jumpbox_admin_username = "azureuser"

dns_zone_name = "daviacandido.com.br"