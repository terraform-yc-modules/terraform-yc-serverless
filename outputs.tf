# Event Router Bus outputs
output "eventrouter_bus_id" {
  description = "ID of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.id
}

output "eventrouter_bus_name" {
  description = "Name of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.name
}

# Event Router Rule outputs
output "eventrouter_rule_id" {
  description = "ID of the Event Router Rule"
  value       = yandex_serverless_eventrouter_rule.main.id
}

output "eventrouter_rule_name" {
  description = "Name of the Event Router Rule"
  value       = yandex_serverless_eventrouter_rule.main.name
}

# Event Router Connector outputs
output "eventrouter_connector_id" {
  description = "ID of the Event Router Connector"
  value       = yandex_serverless_eventrouter_connector.main.id
}

output "eventrouter_connector_name" {
  description = "Name of the Event Router Connector"
  value       = yandex_serverless_eventrouter_connector.main.name
}

# Folder ID output
output "folder_id" {
  description = "Folder ID used for resources"
  value       = local.folder_id
}
