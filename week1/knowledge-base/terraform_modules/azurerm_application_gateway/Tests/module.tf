data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name

}
# RSA key of size 4096 bits
resource "tls_private_key" "test" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_self_signed_cert" "test" {
  private_key_pem = tls_private_key.test.private_key_pem

  subject {
    common_name  = "test.com"
    organization = "ACME tests, Inc"
  }

  validity_period_hours = 1

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "pkcs12_from_pem" "test" {
  depends_on      = [tls_self_signed_cert.test]
  password        = var.name
  cert_pem        = tls_self_signed_cert.test.cert_pem
  private_key_pem = tls_private_key.test.private_key_pem
}

resource "azurerm_key_vault_certificate" "test" {
  depends_on   = [pkcs12_from_pem.test]
  name         = var.name
  key_vault_id = data.azurerm_key_vault.key_vault.id

  certificate {
    contents = pkcs12_from_pem.test.result
    password = var.name # variabale a sustituir en la pipeline
  }
}



module "appgwV2" {
  source                              = "git::ssh://git@ssh.dev.azure.com/v3/Axpo-AXSO/TIM-INFRA-MODULES/azurerm_application_gateway?ref=~{gitRef}~"
  resource_group_name                 = var.resource_group_name
  virtual_network_resource_group_name = var.virtual_network_resource_group_name
  location                            = var.location

  key_vault_name = var.key_vault_name
  key_vault_rbac = var.key_vault_rbac

  subnet_name   = var.vint_subnet_name
  vnet_name     = var.virtual_network_name
  private_ip    = var.frontend_ip_private
  appgw_public  = var.appgw_public
  frontend_port = var.frontend_port

  backend_address_pools = var.backend_address_pools
  backend_http_settings = var.backend_http_settings

  ssl_certificates_keyvault = [
    {
      name                               = var.name
      key_vault_secret_or_certificate_id = azurerm_key_vault_certificate.test.secret_id
    }
  ]

  http_listeners        = var.http_listeners
  probes                = var.probes
  request_routing_rules = var.request_routing_rules
  waf_enabled           = var.waf_enabled
  waf_mode              = var.waf_mode
  sku_name              = var.sku_name
  sku_tier              = var.sku_tier
  capacity              = { min = var.capacity_min, max = var.capacity_max }
}



