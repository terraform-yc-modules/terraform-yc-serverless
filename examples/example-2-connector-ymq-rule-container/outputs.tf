output "bus_id" {
  description = "ID of the Event Router Bus"
  value       = module.eventrouter.bus_id
}

output "bus_name" {
  description = "Name of the Event Router Bus"
  value       = module.eventrouter.bus_name
}

output "rule_id" {
  description = "ID of the Event Router Rule with container target"
  value       = module.eventrouter.rule_id
}

output "rule_name" {
  description = "Name of the Event Router Rule with container target"
  value       = module.eventrouter.rule_name
}

output "connector_id" {
  description = "ID of the Event Router Connector with YMQ source"
  value       = module.eventrouter.connector_id
}

output "connector_name" {
  description = "Name of the Event Router Connector with YMQ source"
  value       = module.eventrouter.connector_name
}

output "folder_id" {
  description = "Folder ID used for resources"
  value       = module.eventrouter.folder_id
}

output "connector_type" {
  description = "Type of connector used (YMQ)"
  value       = "ymq"
}

output "rule_target_type" {
  description = "Type of rule target used (container)"
  value       = "container"
}
