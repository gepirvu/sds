# Example of how to test a module
# -------------------------------#
# module "moudle_name" {
#   source                = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_resource_group?ref=v0.0.0" # update v0.0.0 with the latest version
#   create_default_groups = false
#   subscription          = var.subscription
#   project_name          = var.project_name
#   environment           = var.environment
#   location              = var.location
#   #... other inputs
#   # See all available inputs on the module README.md: https://dev.azure.com/Axpo-AXSO/TIM-INFRA-MODULES/_git/azurerm_resource_group?path=/README.md&_a=preview&anchor=inputs
# }