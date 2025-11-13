resource "azurerm_virtual_network" "vnets" {
  for_each            = var.vnet_details
  name                = each.value.vnet_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  address_space       = each.value.address_space 
  tags     = merge(var.common_tags, each.value.tags)

  dynamic "subnet" {
    for_each = each.value.subnets          #For_each accepts both list as well as map.

    content {
      name             = subnet.value.name
      address_prefixes = subnet.value.address_prefixes
    }
  }
  
   lifecycle {
    ignore_changes = [tags]
    create_before_destroy = true
  }
}
