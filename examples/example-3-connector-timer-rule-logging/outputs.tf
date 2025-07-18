# Event Router Bus outputs
output "bus_id" {
  description = "ID of the Event Router Bus"
  value       = module.eventrouter.bus_id
}

output "bus_name" {
  description = "Name of the Event Router Bus"
  value       = module.eventrouter.bus_name
}

# Event Router Rule outputs
output "rule_id" {
  description = "ID of the Event Router Rule with logging target"
  value       = module.eventrouter.rule_id
}

output "rule_name" {
  description = "Name of the Event Router Rule with logging target"
  value       = module.eventrouter.rule_name
}

# Event Router Connector outputs
output "connector_id" {
  description = "ID of the Event Router Connector with timer source"
  value       = module.eventrouter.connector_id
}

output "connector_name" {
  description = "Name of the Event Router Connector with timer source"
  value       = module.eventrouter.connector_name
}

# Folder ID output
output "folder_id" {
  description = "Folder ID used for resources"
  value       = module.eventrouter.folder_id
}

# Configuration summary outputs
output "connector_type" {
  description = "Type of connector used (timer)"
  value       = "timer"
}

output "rule_target_type" {
  description = "Type of rule target used (logging)"
  value       = "logging"
}
