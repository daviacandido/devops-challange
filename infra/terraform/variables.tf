variable "location" { type = string }
variable "resource_group_name" { type = string }

variable "aks_name" { type = string }
variable "dns_prefix" { type = string }

variable "kubernetes_version" {
  type    = string
  default = null
}

variable "system_node_count" {
  type    = number
  default = 1
}

variable "user_node_count" {
  type    = number
  default = 2
}

variable "user_node_vm_size" {
  type    = string
  default = "Standard_D2s_v6"
}

# em caso de uso de pipeline:
# variable "subscription_id" { type = string }
