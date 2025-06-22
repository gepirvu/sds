#-----------------------------------------------------------------------------------------------------------------------------------------------------------#
# Linux virtual machine scale set
#-----------------------------------------------------------------------------------------------------------------------------------------------------------#

resource "azurerm_linux_virtual_machine_scale_set" "linux_vmss" {
  name                = local.linux_vmss_name
  resource_group_name = var.resource_group_name
  location            = var.location

  # VMSS properties
  sku             = var.linux_vmss_sku
  instances       = var.instances
  overprovision   = var.overprovision
  upgrade_mode    = var.os_upgrade_mode
  zones           = var.availability_zones
  source_image_id = var.source_image_id != null ? var.source_image_id : null


  # VMSS Authentication
  admin_username = var.admin_username

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.generate_admin_ssh_key == true && var.os_flavor == "linux" ? sensitive(tls_private_key.rsa[0].public_key_openssh) : file(var.admin_ssh_key_data)
  }

  dynamic "identity" {
    for_each = var.identity_type != null ? { identity = true } : {}
    content {
      type         = can(regex("SystemAssigned", var.identity_type)) && can(regex("UserAssigned", var.identity_type)) ? "SystemAssigned, UserAssigned" : can(regex("SystemAssigned", var.identity_type)) ? "SystemAssigned" : can(regex("UserAssigned", var.identity_type)) ? "UserAssigned" : null
      identity_ids = can(regex("UserAssigned", var.identity_type)) ? local.managed_identity_ids : null
    }
  }

  # VMSS Image
  dynamic "source_image_reference" {
    for_each = var.source_image_id == null ? ["1"] : []
    content {
      offer     = lookup(var.source_image, "offer", null)
      publisher = lookup(var.source_image, "publisher", null)
      sku       = lookup(var.source_image, "sku", null)
      version   = lookup(var.source_image, "version", null)
    }
  }

  # VMSS Disk

  dynamic "os_disk" {
    for_each = var.os_disk_config != null ? [1] : []
    content {
      caching                = var.os_disk_config.caching
      storage_account_type   = var.os_disk_config.storage_account_type
      disk_size_gb           = var.os_disk_config.disk_size_gb
      disk_encryption_set_id = azurerm_disk_encryption_set.disk_encryption_set.id
    }
  }

  dynamic "data_disk" {
    for_each = var.enable_data_disk == true ? var.data_disks : []

    content {
      #name                   = data_disk.value.name
      lun                    = data_disk.value.lun
      caching                = data_disk.value.caching
      disk_size_gb           = data_disk.value.disk_size_gb
      storage_account_type   = data_disk.value.storage_account_type
      disk_encryption_set_id = azurerm_disk_encryption_set.disk_encryption_set.id
    }
  }


  # VMSS Network

  network_interface {
    name        = "${local.linux_vmss_name}-nic"
    primary     = true
    dns_servers = var.dns_servers

    ip_configuration {
      name      = "${local.linux_vmss_name}-ipconfig"
      primary   = true
      subnet_id = local.linux_vmss_subnet_id
    }
  }

  # VMMSS Encryption

  encryption_at_host_enabled = true

  # VMSS Extension

  dynamic "extension" {
    for_each = var.extension_config.enable ? [1] : []
    content {
      name                       = var.extension_config.name
      publisher                  = var.extension_config.publisher
      type                       = var.extension_config.type
      type_handler_version       = var.extension_config.type_handler_version
      auto_upgrade_minor_version = var.extension_config.auto_upgrade_minor_version

      settings = var.extension_config.settings != null ? jsonencode(var.extension_config.settings) : "{}"
    }
  }

  # VMSS Upgrade Policy

  dynamic "automatic_os_upgrade_policy" {
    for_each = var.os_upgrade_mode == "Automatic" || var.os_upgrade_mode == "Rolling" ? { upgrade = true } : {}
    content {
      disable_automatic_rollback  = true
      enable_automatic_os_upgrade = true
    }
  }

  dynamic "rolling_upgrade_policy" {
    for_each = var.os_upgrade_mode == "Rolling" ? { upgrade = true } : {}
    content {
      max_batch_instance_percent              = 20
      max_unhealthy_instance_percent          = 20
      max_unhealthy_upgraded_instance_percent = 20
      pause_time_between_batches              = "PT0S"
    }
  }

  lifecycle {
    ignore_changes = [extension]
  }

  depends_on = [azurerm_disk_encryption_set.disk_encryption_set, azurerm_key_vault_key.key_vault_key, azurerm_role_assignment.kv_role_assignment]
}

#-----------------------------------------------------------------------------------------------------------------------------------------------------------#