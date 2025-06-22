output "dns_a_record_ids" {
  description = "The FQDNs of the A records."
  value       = azurerm_private_dns_a_record.private_dns_a_record.*.id
}

output "dns_a_record_fqdns" {
  description = "The FQDNs of the A records."
  value       = azurerm_private_dns_a_record.private_dns_a_record.*.fqdn
}