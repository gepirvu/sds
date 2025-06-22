resource "azurerm_virtual_machine_extension" "IaaSAntiMalware" {
  count                      = var.enable_antimalware_extension == true ? 1 : 0
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  name                       = var.antimalware_configuration.name
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntiMalware"
  type_handler_version       = lookup(var.antimalware_configuration, "type_handler_version", "1.3")
  auto_upgrade_minor_version = true

  settings = jsonencode({
    "AntimalwareEnabled" : var.antimalware_configuration.iaas_antimalware_enabled,
    "Exclusions" : var.antimalware_configuration.iaas_antimalware_exclusions,
    "RealtimeProtectionEnabled" : var.antimalware_configuration.iaas_antimalware_protection_enabled,
    "ScheduledScanSettings" : var.antimalware_configuration.iaas_antimalware_scan_settings
  })

  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}


resource "azurerm_virtual_machine_extension" "network_watcher" {
  #for_each                   = local.all_log_analytics_ws
  count = var.enable_network_watcher_extension == true ? 1 : 0

  name                 = "network-watcher"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Azure.NetworkWatcher"
  type                 = "NetworkWatcherAgentWindows"
  type_handler_version = var.network_watcher_type_handler_version #"1.4"
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}


resource "azurerm_virtual_machine_extension" "omsagentwin" {
  count = var.enable_oms_agent_extension == true ? 1 : 0

  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type_handler_version       = var.oms_agent_type_handler_version
  auto_upgrade_minor_version = true
  name                       = "MicrosoftMonitoringAgent"
  type                       = "MicrosoftMonitoringAgent"

  settings = jsonencode({
    "workspaceId" : data.azurerm_log_analytics_workspace.log_analytics_workspace[0].id
  })

  protected_settings = jsonencode({
    "workspaceKey" : data.azurerm_log_analytics_workspace.log_analytics_workspace[0].primary_shared_key
  })
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}


resource "azurerm_virtual_machine_extension" "vmextensionwindows" {
  count = var.enable_disk_encryption_extension == true ? 1 : 0

  name                       = "disk-encryption"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = var.type_handler_version == "" ? "2.2" : var.type_handler_version
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "EncryptionOperation": "${var.encrypt_operation}",
        "KeyVaultURL": "${data.azurerm_key_vault.key_vault.vault_uri}",
        "KeyVaultResourceId": "${data.azurerm_key_vault.key_vault.id}",					
        "KeyEncryptionKeyURL": "${var.encryption_key_url}",
        "KekVaultResourceId": "${data.azurerm_key_vault.key_vault.id}",					
        "KeyEncryptionAlgorithm": "${var.encryption_algorithm}",
        "VolumeType": "${var.disk_encryption_volume_type}"
    }
SETTINGS
  lifecycle {
    ignore_changes = [
      tags
    ]
  }

}
