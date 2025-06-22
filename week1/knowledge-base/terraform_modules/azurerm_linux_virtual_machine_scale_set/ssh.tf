#-----------------------------------------------------------------------------------------------------------------#
# Generates SSH2 RSA key pair for the LINUX VMSS
#-----------------------------------------------------------------------------------------------------------------#

resource "tls_private_key" "rsa" {
  count     = var.generate_admin_ssh_key == true && var.os_flavor == "linux" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Store the public and private key in the Key Vault

resource "azurerm_key_vault_secret" "admin_ssh_public_key" {
  count        = var.generate_admin_ssh_key == true && var.os_flavor == "linux" ? 1 : 0
  name         = "linux-vmss-adminuser-ssh-public"
  value        = tls_private_key.rsa[0].public_key_openssh
  key_vault_id = local.key_vault_id
}

resource "azurerm_key_vault_secret" "admin_ssh_private_key" {
  count        = var.generate_admin_ssh_key == true && var.os_flavor == "linux" ? 1 : 0
  name         = "linux-vmss-adminuser-ssh-private"
  value        = tls_private_key.rsa[0].private_key_pem
  key_vault_id = local.key_vault_id
}

#-----------------------------------------------------------------------------------------------------------------#