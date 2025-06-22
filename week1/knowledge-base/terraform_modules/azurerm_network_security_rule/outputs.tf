output "nsg_rules_map" {
  value       = { for rule in var.nsg_rules : rule.nsg_rule_name => rule }
  description = "Output map of NSG rules created"
}