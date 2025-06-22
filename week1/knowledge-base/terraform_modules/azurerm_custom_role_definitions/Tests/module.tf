##################################################
# MODULES                                        #
##################################################
module "custom_roles" {
  source                  = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_custom_role_definitions?ref=~{gitRef}~"
  count                   = var.deploy_custom_roles == true ? 1 : 0
  custom_role_definitions = var.custom_role_definitions
}