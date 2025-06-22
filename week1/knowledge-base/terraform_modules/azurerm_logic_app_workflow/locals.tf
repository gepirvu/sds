locals {
  logic_app_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-logicapp-${var.logic_app_description}")
}