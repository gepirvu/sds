locals {
  app_insights_name = lower("axso-${var.subscription}-appl-${var.project_name}-${var.environment}-insights")
}