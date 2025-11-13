variable "kv_details" {
  type = map(object({
    kv_name                     = string
    location                    = string
    rg_name                     = string
    enabled_for_disk_encryption = optional(bool)
    soft_delete_retention_days  = number
    purge_protection_enabled    = optional(bool)
    sku_name                    = string
    tags                        = optional(map(string), {})

  }))
}
variable "common_tags" {
  type    = map(string)
  default = {}
}