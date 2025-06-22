#Custom Roles
deploy_custom_roles = true
custom_role_definitions = [
  {
    role_definition_name = "CUSTOM - App Settings Reader - tf-testing-~{environment}~"
    description          = "Allows view access for Azure Sites Configuration - This is just a testing role definition (PLEASE DELETE ME)"
    permissions = {
      actions          = ["Microsoft.Web/sites/config/list/action", "Microsoft.Web/sites/config/read"]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
  },
  {
    role_definition_name = "CUSTOM - App Settings Admin - tf-testing-~{environment}~"
    description          = "Allows edit access for Azure Sites Configuration - This is just a testing role definition (PLEASE DELETE ME)"
    permissions = {
      actions          = ["Microsoft.Web/sites/config/*"]
      data_actions     = []
      not_actions      = []
      not_data_actions = []
    }
  }
]