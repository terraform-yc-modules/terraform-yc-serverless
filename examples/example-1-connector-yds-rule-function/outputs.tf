# Event Router Bus outputs
output "eventrouter_bus_id" {
  description = "ID of the Event Router Bus"
  value       = module.eventrouter.eventrouter_bus_id
}

output "eventrouter_bus_name" {
  description = "Name of the Event Router Bus"
  value       = module.eventrouter.eventrouter_bus_name
}

# Event Router Rule outputs
output "eventrouter_rule_id" {
  description = "ID of the Event Router Rule with function target"
  value       = module.eventrouter.eventrouter_rule_id
}

output "eventrouter_rule_name" {
  description = "Name of the Event Router Rule with function target"
  value       = module.eventrouter.eventrouter_rule_name
}

# Event Router Connector outputs
output "eventrouter_connector_id" {
  description = "ID of the Event Router Connector with YDS source"
  value       = module.eventrouter.eventrouter_connector_id
}

output "eventrouter_connector_name" {
  description = "Name of the Event Router Connector with YDS source"
  value       = module.eventrouter.eventrouter_connector_name
}

# Folder ID output
output "folder_id" {
  description = "Folder ID used for resources"
  value       = module.eventrouter.folder_id
}

# Configuration summary outputs
output "connector_type" {
  description = "Type of connector used (YDS)"
  value       = "yds"
}

output "rule_target_type" {
  description = "Type of rule target used (function)"
  value       = "function"
}
