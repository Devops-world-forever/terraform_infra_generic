variable "vnet_details" {
  type = map(object({
    vnet_name     = string
    location      = string
    rg_name       = string
    address_space = list(string)
    tags          = optional(map(string), {})
    subnets = optional(list(object({         
      name             = string
      address_prefixes = list(string)
    })), [])
  }))
}
variable "common_tags" {
  type    = map(string)
  default = {}
}