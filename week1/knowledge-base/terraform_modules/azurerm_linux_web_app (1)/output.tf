output "app_service_ids" {
  value = {
    for _, web_app in azurerm_linux_web_app.lin :
    web_app.id => web_app.id
  }
  description = "The App Service IDs"
}

output "app_service_names" {
  value = {
    for _, web_app in azurerm_linux_web_app.lin :
    web_app.name => web_app.name
  }
  description = "The App Service Names"
}
