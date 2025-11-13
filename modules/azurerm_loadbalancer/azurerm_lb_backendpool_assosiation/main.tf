data "azurerm_lb" "lb" {
  for_each = { for idx, val in var.backend_address_pool_ass_details : idx => val }

  name                = each.value.lb_name
  resource_group_name = each.value.rg_name
}

data "azurerm_lb_backend_address_pool" "backendpools" {
  for_each = { for idx, val in var.backend_address_pool_ass_details : idx => val }

  name            = each.value.backendpool_name
  loadbalancer_id = data.azurerm_lb.lb[each.key].id
}

data "azurerm_network_interface" "nic" {
  for_each = { for idx, val in var.backend_address_pool_ass_details : idx => val }

  name                = each.value.nic_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_network_interface_backend_address_pool_association" "example" {
  for_each = { for idx, val in var.backend_address_pool_ass_details : idx => val }

  network_interface_id    = data.azurerm_network_interface.nic[each.key].id
  ip_configuration_name   = each.value.ip_configuration_name
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.backendpools[each.key].id
}


# idx ko key banaya map me
# val (object) ko value banaya map me
# Iska result hoga:
# {
#   0 = { backendpool_name = "pool1", nic_name = "frontendvm-nic", ... }
#   1 = { backendpool_name = "pool2", nic_name = "backendvm-nic", ... }
# }



# data "azurerm_network_interface" "example" {
#   name                = "acctest-nic"
#   resource_group_name = "networking"
# }

# output "network_interface_id" {
#   value = data.azurerm_network_interface.example.id
# } 