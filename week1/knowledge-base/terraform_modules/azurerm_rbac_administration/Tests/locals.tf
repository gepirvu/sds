locals {
  azure_rbac_config = [
    {
      description          = "Example - Azure RBAC permision on Resource Group"
      scope                = data.azurerm_resource_group.infra_test_resource_group.id
      role_definition_name = "Reader"
      principal_id         = data.azurerm_client_config.current.object_id # Retrieves the "current" object_id from the azurerm_client_config data source
    }
  ]
}