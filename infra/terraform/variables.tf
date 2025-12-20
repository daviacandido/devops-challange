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

# Rede
variable "vnet_name" { type = string }
variable "vnet_cidr" { type = string }

variable "aks_subnet_name" { type = string }
variable "aks_subnet_cidr" { type = string }

variable "jumpbox_subnet_name" { type = string }
variable "jumpbox_subnet_cidr" { type = string }

variable "bastion_subnet_cidr" { type = string }

variable "bastion_name" { type = string }

variable "jumpbox_name" { type = string }
variable "jumpbox_vm_size" {
  type    = string
  default = "Standard_D2s_v6"
}

variable "jumpbox_admin_username" { type = string }

variable "jumpbox_admin_ssh_public_key" {
  type        = string
  description = "SSH public key used to access the jumpbox VM"

  validation {
    condition     = length(trimspace(var.jumpbox_admin_ssh_public_key)) > 0
    error_message = "jumpbox_admin_ssh_public_key must not be empty. Provide it via TF_VAR_jumpbox_admin_ssh_public_key or tfvars."
  }
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API token."
  sensitive   = true
}


