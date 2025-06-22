module "axso_nsg_rules" {
  for_each            = toset(var.network_security_groups)
  source              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_network_security_rule?ref=~{gitRef}~"
  resource_group_name = var.resource_group_name
  nsg_name            = each.key
  nsg_rules           = lookup(local.nsg_config[each.key], "nsgRules", null)
}