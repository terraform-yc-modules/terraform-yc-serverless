# Event Router Bus outputs
output "bus_id" {
  description = "ID of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.id
}

output "bus_name" {
  description = "Name of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.name
}

# Event Router Rule outputs
output "rule_id" {
  description = "ID of the Event Router Rule"
  value       = yandex_serverless_eventrouter_rule.main.id
}

output "rule_name" {
  description = "Name of the Event Router Rule"
  value       = yandex_serverless_eventrouter_rule.main.name
}

# Event Router Connector outputs
output "connector_id" {
  description = "ID of the Event Router Connector"
  value       = yandex_serverless_eventrouter_connector.main.id
}

output "connector_name" {
  description = "Name of the Event Router Connector"
  value       = yandex_serverless_eventrouter_connector.main.name
}

# Folder ID output
output "folder_id" {
  description = "Folder ID used for resources"
  value       = local.folder_id
}
