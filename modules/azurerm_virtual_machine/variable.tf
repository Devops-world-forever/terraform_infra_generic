variable "vms_detail" {
  type = map(object({
    nic_name             = string
    location             = string
    rg_name              = string
    vm_ip_name           = string
    vm_name              = string
    subnet_name          = string
    virtual_network_name = string
    kv_name              = string
    size                 = string
    tags                 = optional(map(string), {})
  }))
}
variable "common_tags" {
  type    = map(string)
  default = {}
}