locals {
  vm_name                  = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-vmw-${var.vm_number}")
  computer_name            = lower("${var.project_name}-${var.environment}-${var.vm_number}")
  vm_nic_name              = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-vmw-${var.vm_number}-nic-${var.vm_nic_number}")
  vm_os_disk_name          = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-vmw-${var.vm_number}-osdisk")
  vm_data_disk_name        = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-vmw-${var.vm_number}-datadisk")
  disk_encryption_set_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-des-${var.vm_number}")
  disk_encryption_key_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-key-${random_string.string.result}")
}

locals {
  days_to_hours = 365 * 24
  // expiration date need to be in a specific format as well
  expiration_date = timeadd(formatdate("YYYY-MM-DD'T'HH:mm:ssZ", timestamp()), "${local.days_to_hours}h")
}

resource "random_string" "string" {
  length      = 4
  upper       = false
  min_numeric = 1
  special     = false
}