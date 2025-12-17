provider "azurerm" {
  features {}
}

# em caso de uso de pipeline:
# provider "azurerm" {
#   features {}
#   subscription_id = var.subscription_id
# }