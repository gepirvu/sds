###################
# Module to test  #
###################

module "role-assignment" {
  source            = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_rbac_administration?ref=~{gitRef}~"
  azure_rbac_config = local.azure_rbac_config
}