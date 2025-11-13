data "azurerm_subnet" "subnet" {
  for_each             = var.vms_detail
  name                 = each.value.subnet_name
  virtual_network_name = each.value.virtual_network_name
  resource_group_name  = each.value.rg_name
}

data "azurerm_key_vault" "kv" {
  for_each            = var.vms_detail
  name                = each.value.kv_name
  resource_group_name = each.value.rg_name
}

resource "random_password" "pwd" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "azurerm_key_vault_secret" "vmpass" {
  for_each     = var.vms_detail
  name         = "${each.value.vm_name}-password"
  value        = random_password.pwd.result
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}


resource "azurerm_network_interface" "nic" {
  for_each            = var.vms_detail
  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = each.value.vm_ip_name 
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = lookup(each.value, "private_ip_address_allocation", "Dynamic")
  }
}

resource "azurerm_linux_virtual_machine" "vms" {
  for_each            = var.vms_detail
  name                = each.value.vm_name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  size                = lookup(each.value, "size", "Standard_F2")
  admin_username      = "devops_admin"
  admin_password      = azurerm_key_vault_secret.vmpass[each.key].value
  network_interface_ids = [
    azurerm_network_interface.nic[each.key].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
tags     = merge(var.common_tags, each.value.tags)
}
