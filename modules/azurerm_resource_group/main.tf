resource "azurerm_resource_group" "rgs" {
  for_each = var.rg_details
  name     = each.value.rg_name
  location = each.value.location
  tags     = merge(var.common_tags, each.value.tags)

  lifecycle {
    ignore_changes        = [tags]
    create_before_destroy = true
    prevent_destroy       = true
  }
}
