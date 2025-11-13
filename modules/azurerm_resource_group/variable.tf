variable "rg_details" {
  type = map(object({
    rg_name  = string
    location = string
    tags     = optional(map(string), {})
  }))
}
variable "common_tags" {
  type    = map(string)
  default = {}
}