data "azurerm_subnet" "subnet_data" {
  for_each             = var.bastion_details
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name #"production"
  resource_group_name  = each.value.rg_name   #"networking"
}

resource "azurerm_public_ip" "ips" {
  for_each             = var.bastion_details
  name                = each.value.ip_name 
  location            = each.value.location
  resource_group_name = each.value.rg_name

  allocation_method   = lookup(each.value, "allocation_method", "Static")
  sku  = lookup(each.value, "sku", "Standard")
  tags = each.value.tags
}

resource "azurerm_bastion_host" "bastion" {
  for_each             = var.bastion_details
  name                = each.value.bastion_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                 = azurerm_public_ip.ips[each.key].name
    subnet_id            = data.azurerm_subnet.subnet_data[each.key].id
    public_ip_address_id = azurerm_public_ip.ips[each.key].id
  }
  tags     = merge(var.common_tags, each.value.tags)
}

