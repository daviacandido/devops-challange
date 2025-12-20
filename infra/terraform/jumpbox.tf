resource "azurerm_network_security_group" "nsg_jumpbox" {
  name                = "nsg-jumpbox"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "jumpbox" {
  subnet_id                 = azurerm_subnet.snet_jumpbox.id
  network_security_group_id = azurerm_network_security_group.nsg_jumpbox.id
}

resource "azurerm_network_interface" "jumpbox_nic" {
  name                = "nic-jumpbox"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.snet_jumpbox.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "jumpbox" {
  name                = var.jumpbox_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = var.jumpbox_vm_size
  admin_username      = var.jumpbox_admin_username

  network_interface_ids = [
    azurerm_network_interface.jumpbox_nic.id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.jumpbox_admin_username
    public_key = var.jumpbox_admin_ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile(
    "${path.module}/cloud-init/jumpbox.yaml",
    {
      ci_repo         = var.ci_repo
      ci_runner_token = var.ci_runner_token
    }
  ))
}
