output "rg_ids" {
  value = { for k, rg in azurerm_resource_group.rgs : k => rg.id }
}
