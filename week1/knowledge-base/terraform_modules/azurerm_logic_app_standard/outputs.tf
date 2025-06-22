output "logicapp_ids" {
  value = {
    for _, logicapp in azurerm_logic_app_standard.logicapp :
    logicapp.id => logicapp.id
  }
  description = "The Logic App ID"
}

