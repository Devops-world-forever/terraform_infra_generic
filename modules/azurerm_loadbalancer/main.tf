resource "azurerm_public_ip" "pip" {
for_each        = { for idx, lb in var.lb_details : idx => lb }
  name                = each.value.pip_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  allocation_method   = each.value.allocation_method 
}

resource "azurerm_lb" "loadbalancer" {
for_each        = { for idx, lb in var.lb_details : idx => lb }
  name                = each.value.lb_name #"TestLoadBalancer"
  location            = each.value.location
  resource_group_name = each.value.rg_name

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration_name #"PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.pip[each.key].id
  }
  tags=merge(each.value.tags,var.common_tags)
}

# Backend pool
resource "azurerm_lb_backend_address_pool" "backendpool" {
  for_each        = { for idx, lb in var.lb_details : idx => lb }
  name            = each.value.backendpool_name
  loadbalancer_id = azurerm_lb.loadbalancer[each.key].id  # single LB
}

# for idx, lb in var.lb_details	Ye ek loop hai jo list ke har element pe chalega. idx = index (0,1,2...) aur lb = har object
# idx => lb	Har index ko key bana raha hai aur object (lb) ko value.
# { ... }	Ye curly braces map banate hain.

# Health probe
resource "azurerm_lb_probe" "probe" {
  for_each        = { for idx, lb in var.lb_details : idx => lb }
  loadbalancer_id     = azurerm_lb.loadbalancer[each.key].id
  name                = each.value.probe_name #"HealthProbe"
  protocol            = "Tcp"
  port                = each.value.port #80
}

# Load balancing rule
resource "azurerm_lb_rule" "lb_rule" {
 for_each        = { for idx, lb in var.lb_details : idx => lb }
  loadbalancer_id     = azurerm_lb.loadbalancer[each.key].id
  name                           = each.value.lb_rule_name #"HTTPRule"
  protocol                       = "Tcp"
  frontend_port                  = each.value.port #80
  backend_port                   = each.value.port #80
  frontend_ip_configuration_name = azurerm_lb.loadbalancer[each.key].frontend_ip_configuration[0].name
  probe_id                       = azurerm_lb_probe.probe[each.key].id
}

