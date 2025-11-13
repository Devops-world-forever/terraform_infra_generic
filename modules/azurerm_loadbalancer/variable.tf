variable "lb_details" {
  type = list(object({
    pip_name                       = string
    location                       = string
    rg_name                        = string
    allocation_method              = string
    lb_name                        = string
    frontend_ip_configuration_name = string
    backendpool_name               = string
    probe_name                     = string
    port                           = number
    lb_rule_name                   = string
    frontend_port                  = number
    backend_port                   = number
    tags                           = optional(map(string), {})
  }))
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
