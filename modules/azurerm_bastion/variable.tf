variable "bastion_details" {
  type = map(object({
    subnet_name       = string
    vnet_name         = string
    rg_name           = string
    ip_name           = string
    location          = string
    allocation_method = string
    sku               = optional(string)
    bastion_name      = string
    tags              = optional(map(string), {})
  }))
}
variable "common_tags" {
  type    = map(string)
  default = {}
}