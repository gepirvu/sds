resource "azurerm_role_assignment" "webapp_role_assignment_key_vault" {
  for_each             = var.webapp_custom_certificates_key_vault != null ? var.webapp_custom_certificates : {}
  role_definition_name = "Key Vault Certificate User"
  principal_id         = data.azuread_service_principal.MicrosoftWebApp.object_id
  scope                = "${data.azurerm_key_vault.webapp_cert_key_vault[0].id}/secrets/${each.value.keyvault_certificate_name}"
  depends_on           = [azurerm_linux_web_app.lin]
}

resource "azurerm_app_service_certificate" "app_certificate" {
  for_each            = { for webapp_certificate_friendly_name, config in var.webapp_custom_certificates : config.keyvault_certificate_name => config }
  name                = each.value.webapp_certificate_friendly_name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_id        = data.azurerm_key_vault.webapp_cert_key_vault[0].id
  key_vault_secret_id = data.azurerm_key_vault_secret.key_vault_secret[each.key].id
  app_service_plan_id = azurerm_service_plan.azure_serviceplan.id
  depends_on          = [resource.azurerm_role_assignment.webapp_role_assignment_key_vault, time_sleep.wait_30_seconds_destroy]
  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_private_dns_a_record" "pe_record" {
  for_each = {
    for name, config in local.webapps_with_custom_domains :
    name => config
    if contains(keys(local.private_ip_addresses), config.webapp_description)
  }

  name                = each.value.webapp_custom_domain_name != "@" ? each.value.webapp_custom_domain_name : "@"
  zone_name           = var.private_dns_zone_name
  resource_group_name = local.private_dns_resource_group_name
  ttl                 = 300
  records             = [local.private_ip_addresses[each.value.webapp_description]]

  depends_on = [azurerm_private_endpoint.private_endpoint]
  provider   = azurerm.dns
}


resource "azurerm_dns_txt_record" "txt_record" {
  for_each            = local.verification_id
  name                = var.webapp_custom_domains[each.key].webapp_custom_domain_name != "@" && local.env_domain != "" ? "asuid.${var.webapp_custom_domains[each.key].webapp_custom_domain_name}.${local.env_domain}" : (var.webapp_custom_domains[each.key].webapp_custom_domain_name != "@" && local.env_domain == "" ? "asuid.${var.webapp_custom_domains[each.key].webapp_custom_domain_name}" : (var.webapp_custom_domains[each.key].webapp_custom_domain_name == "@" && local.env_domain != "" ? "asuid.${local.env_domain}" : "asuid"))
  zone_name           = var.public_dns_zone_name
  resource_group_name = local.public_dns_resource_group_name
  ttl                 = 300
  provider            = azurerm.dns

  record {
    value = each.value == "" ? "validated" : each.value
  }

  lifecycle {
    ignore_changes = [record]
  }

}

resource "time_sleep" "wait_30_seconds_destroy" {
  depends_on = [azurerm_app_service_custom_hostname_binding.hostname_binding]

  destroy_duration = "60s"
}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [azurerm_dns_txt_record.txt_record]

  create_duration = "60s"
}


resource "azurerm_app_service_custom_hostname_binding" "hostname_binding" {
  for_each            = { for webapp_certificate_friendly_name, config in local.webapps_with_custom_domains : webapp_certificate_friendly_name => config }
  hostname            = each.value.webapp_custom_domain_name != "@" ? "${each.value.webapp_custom_domain_name}.${var.private_dns_zone_name}" : var.private_dns_zone_name
  app_service_name    = azurerm_linux_web_app.lin[each.value.webapp_description].name
  resource_group_name = var.resource_group_name
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }

  depends_on = [time_sleep.wait_30_seconds]

}

resource "azurerm_app_service_certificate_binding" "certificate_binding" {
  for_each            = { for webapp_certificate_friendly_name, config in local.webapps_with_custom_domains : webapp_certificate_friendly_name => config }
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.hostname_binding[each.key].id
  certificate_id      = azurerm_app_service_certificate.app_certificate[each.value.webapp_certificate_friendly_name].id
  ssl_state           = "SniEnabled"
  depends_on          = [azurerm_app_service_custom_hostname_binding.hostname_binding, azurerm_app_service_certificate.app_certificate]
}

