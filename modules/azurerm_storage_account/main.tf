resource "azurerm_storage_account" "strg" {
  for_each                 = var.strg_details
  name                     = each.value.strg_name
  resource_group_name      = each.value.rg_name
  location                 = each.value.location
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  tags     = merge(var.common_tags, each.value.tags)
}