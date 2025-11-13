variable "nsgass" {
  type = map(object({
    subnet_name = list(string)
    vnet_name   = string
    rg_name     = string
    nsg_name    = string
  }))
}
