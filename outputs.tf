output "bus_id" {
  description = "ID of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.id
}

output "bus_name" {
  description = "Name of the Event Router Bus"
  value       = yandex_serverless_eventrouter_bus.main.name
}

output "rule_ids" {
  description = "IDs of the Event Router Rules"
  value       = { for k, v in yandex_serverless_eventrouter_rule.rules : k => v.id }
}

output "rule_names" {
  description = "Names of the Event Router Rules"
  value       = { for k, v in yandex_serverless_eventrouter_rule.rules : k => v.name }
}

output "connector_ids" {
  description = "IDs of the Event Router Connectors"
  value       = { for k, v in yandex_serverless_eventrouter_connector.connectors : k => v.id }
}

output "connector_names" {
  description = "Names of the Event Router Connectors"
  value       = { for k, v in yandex_serverless_eventrouter_connector.connectors : k => v.name }
}
