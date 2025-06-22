locals {
  route_table_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-${var.usecase}-rt")
  next_hop_in_ip_address = {
    westeurope = {
      hub_ip = "10.84.1.4"
    },
    northeurope = {
      hub_ip = "10.86.1.4"
    },
    switzerlandnorth = {
      hub_ip = "10.82.1.4"
    }
  }
}

