resource "azurerm_network_security_group" "nsg" {
  for_each            = var.nsg_details
  name                = each.value.nsg_name #"TestSecurityGroup"
  location            = each.value.location #"central india"
  resource_group_name = each.value.rg_name  #"dev-rg"

  #   security_rule {
  #     name                       = "test123"
  #     priority                   = 100
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "Tcp"
  #     source_port_range          = "*"
  #     destination_port_range     = "*"
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "*"
  #   }

  #  
  # }

   # security_rules = [
  #   {
  #     name                       = "allow-ssh"
  #     priority                   = 100
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "Tcp"
  #     source_port_range          = "*"
  #     destination_port_range     = "22"
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "*"
  #   },
  #   {
  #     name                       = "allow-http"
  #     priority                   = 101
  #     direction                  = "Inbound"
  #     access                     = "Allow"
  #     protocol                   = "Tcp"
  #     source_port_range          = "*"
  #     destination_port_range     = "80"
  #     source_address_prefix      = "*"
  #     destination_address_prefix = "*"
  #   }
  # ]

  # resource "azurerm_network_security_group" "nsg" {
  #   name                = "my-nsg"
  #   location            = "centralindia"
  #   resource_group_name = "dev-rg"

  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  tags = merge(var.common_tags, each.value.tags)
}

