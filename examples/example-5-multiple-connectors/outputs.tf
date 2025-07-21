output "bus_id" {
  description = "ID of the Event Router Bus"
  value       = module.eventrouter.bus_id
}

output "bus_name" {
  description = "Name of the Event Router Bus"
  value       = module.eventrouter.bus_name
}

output "rule_ids" {
  description = "Map of Event Router Rule IDs"
  value       = module.eventrouter.rule_ids
}

output "rule_names" {
  description = "Map of Event Router Rule names"
  value       = module.eventrouter.rule_names
}

output "connector_ids" {
  description = "Map of Event Router Connector IDs"
  value       = module.eventrouter.connector_ids
}

output "connector_names" {
  description = "Map of Event Router Connector names"
  value       = module.eventrouter.connector_names
}

output "folder_id" {
  description = "Folder ID used for resources"
  value       = module.eventrouter.folder_id
}
