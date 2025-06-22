data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "infra_test_resource_group" {
  name = "axso-np-appl-ssp-test-rg"
}