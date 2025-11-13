data "azurerm_subnet" "subnets" {
  for_each             = toset(var.nsgass["nsgass1"].subnet_name)
  name                 = each.value
  virtual_network_name = var.nsgass["nsgass1"].vnet_name
  resource_group_name  = var.nsgass["nsgass1"].rg_name
}

data "azurerm_network_security_group" "nsg" {
  for_each             = var.nsgass
  name                = each.value.nsg_name
  resource_group_name = each.value.rg_name
} 

resource "azurerm_subnet_network_security_group_association" "nsgassociation" {
    for_each = data.azurerm_subnet.subnets
    subnet_id                 = each.value.id
    network_security_group_id = data.azurerm_network_security_group.nsg["nsgass1"].id
  } 
