location            = "Brazil South"
resource_group_name = "rg-aks-poc-bry"

aks_name   = "aks-poc-bry"
dns_prefix = "poc-bry"

# deixe null para usar o default do AKS (ok pro desafio)
kubernetes_version = null

system_node_count = 1
user_node_count   = 2

user_node_vm_size = "Standard_D2s_v6"