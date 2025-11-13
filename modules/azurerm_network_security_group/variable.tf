variable "nsg_details" {
  type = map(object({
    rg_name     = string
    location    = string
    nsg_name    = string
    tags        = optional(map(string), {})
    security_rules = list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    }))
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
