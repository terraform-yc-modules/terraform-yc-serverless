output "bus_id" {
  description = "ID of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.id
}

output "bus_name" {
  description = "Name of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.name
}

output "rule_ids" {
  description = "Map of Event Router Rule IDs"
  value       = { for k, v in yandex_serverless_eventrouter_rule.main : k => v.id }
}

output "rule_names" {
  description = "Map of Event Router Rule names"
  value       = { for k, v in yandex_serverless_eventrouter_rule.main : k => v.name }
}

output "rule_id" {
  description = "[DEPRECATED] Use rule_ids instead. ID of the first Event Router Rule"
  value       = length(yandex_serverless_eventrouter_rule.main) > 0 ? values(yandex_serverless_eventrouter_rule.main)[0].id : null
}

output "rule_name" {
  description = "[DEPRECATED] Use rule_names instead. Name of the first Event Router Rule"
  value       = length(yandex_serverless_eventrouter_rule.main) > 0 ? values(yandex_serverless_eventrouter_rule.main)[0].name : null
}

output "connector_ids" {
  description = "Map of Event Router Connector IDs"
  value       = { for k, v in yandex_serverless_eventrouter_connector.main : k => v.id }
}

output "connector_names" {
  description = "Map of Event Router Connector names"
  value       = { for k, v in yandex_serverless_eventrouter_connector.main : k => v.name }
}

output "connector_id" {
  description = "[DEPRECATED] Use connector_ids instead. ID of the first Event Router Connector"
  value       = length(yandex_serverless_eventrouter_connector.main) > 0 ? values(yandex_serverless_eventrouter_connector.main)[0].id : null
}

output "connector_name" {
  description = "[DEPRECATED] Use connector_names instead. Name of the first Event Router Connector"
  value       = length(yandex_serverless_eventrouter_connector.main) > 0 ? values(yandex_serverless_eventrouter_connector.main)[0].name : null
}

output "folder_id" {
  description = "Folder ID used for resources"
  value       = local.folder_id
}
