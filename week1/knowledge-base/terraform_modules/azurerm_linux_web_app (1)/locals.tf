locals {
  serviceplan_name    = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.service_plan_os_type}-${var.service_plan_usage}-asp")
  private_dns_zone_id = "/subscriptions/36cae50e-ce2a-438f-bd97-216b7f682c77/resourceGroups/rg-privatedns-pe-prod-axpo/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
  app_services_with_acr = {
    for app in var.app_services :
    app.appservice_short_description => app
    if app.use_acr
  }
}

locals {
  public_dns_resource_group_name  = "rg-publicdns-prod-axpo-cloud"
  private_dns_resource_group_name = "rg-privatedns-prod-axpo"

  webapps_with_custom_domains = {
    for k, v in var.webapp_custom_domains : k => v

  }

  private_ip_addresses = {
    for name, pe in azurerm_private_endpoint.private_endpoint :
    name => pe.private_service_connection[0].private_ip_address
  }

  verification_id = {
    for domain_name, config in var.webapp_custom_domains :
    config.webapp_description => azurerm_linux_web_app.lin[config.webapp_description].custom_domain_verification_id
  }

  # Extract the part before the base domain
  extracted_prefix = var.webapp_custom_domains != null ? replace(var.private_dns_zone_name, "/${var.public_dns_zone_name}$/", "") : ""

  # Extract the 'env' part by removing the trailing dot if it exists
  env_domain = replace(local.extracted_prefix, ".", "")
}