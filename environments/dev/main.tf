module "azurerm_resource_group" {
  source      = "../../modules/azurerm_resource_group"
  rg_details  = var.rg_details
  common_tags = local.common_tags
}

module "azurerm_storage_account" {
  depends_on   = [module.azurerm_resource_group]
  source       = "../../modules/azurerm_storage_account"
  strg_details = var.strg_details
  common_tags  = local.common_tags
}

module "azurerm_virtual_network" {
  depends_on   = [module.azurerm_resource_group]
  source       = "../../modules/azurerm_virtual_network"
  vnet_details = var.vnet_details
  common_tags  = local.common_tags
}

module "azurerm_bastion" {
  depends_on      = [module.azurerm_virtual_network, module.azurerm_resource_group]
  source          = "../../modules/azurerm_bastion"
  bastion_details = var.bastion_details
  common_tags     = local.common_tags
}

module "azurerm_key_vault" {
  depends_on  = [module.azurerm_resource_group]
  source      = "../../modules/azurerm_key_vault"
  kv_details  = var.kv_details
  common_tags = local.common_tags

}

module "azurerm_virtual_machine" {
  depends_on  = [module.azurerm_resource_group, module.azurerm_virtual_network, module.azurerm_key_vault]
  source      = "../../modules/azurerm_virtual_machine"
  vms_detail  = var.vms_detail
  common_tags = local.common_tags
}

module "azurerm_network_security_group" {
  depends_on  = [module.azurerm_resource_group, module.azurerm_virtual_network]
  source      = "../../modules/azurerm_network_security_group"
  nsg_details = var.nsg_details
  common_tags = local.common_tags
}
module "azurerm_nsg_association" {
  depends_on = [module.azurerm_resource_group, module.azurerm_virtual_network, module.azurerm_network_security_group]
  source     = "../../modules/azurerm_nsg_association"
  nsgass     = var.nsgass
}
module "azurerm_loadbalancer" {
  depends_on = [  module.azurerm_resource_group]
  source      = "../../modules/azurerm_loadbalancer"
  lb_details  = var.lb_details
  common_tags = local.common_tags
}

module "backendpool_association" {
  depends_on = [ module.azurerm_resource_group,module.azurerm_loadbalancer, module.azurerm_virtual_machine]
  source = "../../modules/azurerm_loadbalancer/azurerm_lb_backendpool_assosiation"
  backend_address_pool_ass_details = var.backend_address_pool_ass_details 
}