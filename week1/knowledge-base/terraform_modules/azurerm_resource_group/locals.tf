locals {
  resource_group_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-rg")
}