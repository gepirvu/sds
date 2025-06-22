locals {
  monitor_workspace_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-mws")
}
