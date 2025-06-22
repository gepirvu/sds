# Purpose: Define the output variables for the Terraform configuration.

# Output for function app id
output "function_app_ids" {
  value = {
    for usecase, app in azurerm_linux_function_app.function_app : usecase => app.id
  }
}

# Output for function app name
output "function_app_names" {
  value = {
    for usecase, app in azurerm_linux_function_app.function_app : usecase => app.name
  }
}

# Output for function app default_hostname
output "function_app_default_hostnames" {
  value = {
    for usecase, app in azurerm_linux_function_app.function_app : usecase => app.default_hostname
  }
}