variable "backend_address_pool_ass_details" {
  type = list(object({
    lb_name               = string
    rg_name               = string
    backendpool_name      = string  # single backend pool per object
    nic_name              = string  # single NIC per object
    ip_configuration_name = string
  }))
}