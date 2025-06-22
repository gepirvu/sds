resource "azurerm_windows_virtual_machine" "vm" {
  depends_on          = [azurerm_role_assignment.role_assignment]
  name                = local.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name

  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = var.vm_size

  source_image_id = var.vm_image_id

  dynamic "source_image_reference" {
    for_each = var.vm_image_id == null ? ["1"] : []
    content {
      offer     = lookup(var.vm_image, "offer", null)
      publisher = lookup(var.vm_image, "publisher", null)
      sku       = lookup(var.vm_image, "sku", null)
      version   = lookup(var.vm_image, "version", null)
    }
  }


  availability_set_id = var.availability_set_id

  proximity_placement_group_id = var.proximity_placement_group_id

  encryption_at_host_enabled = var.encryption_at_host_enabled

  zone = var.zone_id
  dynamic "boot_diagnostics" {
    for_each = var.diagnostics_storage_account_name != null ? ["1"] : []
    content {

      storage_account_uri = "https://${var.diagnostics_storage_account_name}.blob.core.windows.net"

    }
  }

  os_disk {
    name                   = local.vm_os_disk_name
    caching                = var.os_disk_caching
    storage_account_type   = var.os_disk_storage_account_type
    disk_size_gb           = var.os_disk_size_gb
    disk_encryption_set_id = azurerm_disk_encryption_set.disk_encryption_set.id
  }

  dynamic "identity" {
    for_each = var.identity != null ? ["1"] : []
    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }

  computer_name  = local.computer_name
  admin_username = var.admin_username
  admin_password = azurerm_key_vault_secret.vm_secret.value

  custom_data = var.custom_data
  user_data   = var.user_data

  priority        = var.spot_instance ? "Spot" : "Regular"
  max_bid_price   = var.spot_instance ? var.spot_instance_max_bid_price : null
  eviction_policy = var.spot_instance ? var.spot_instance_eviction_policy : null

  enable_automatic_updates = var.enable_automatic_updates
  hotpatching_enabled      = var.hotpatching_enabled

  patch_mode                                             = var.patch_mode
  patch_assessment_mode                                  = var.patch_mode == "AutomaticByPlatform" ? var.patch_mode : "ImageDefault"
  bypass_platform_safety_checks_on_user_schedule_enabled = var.patch_mode == "AutomaticByPlatform"
  reboot_setting                                         = var.patch_mode == "AutomaticByPlatform" ? var.patching_reboot_setting : null
  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}


