output "bus_id" {
  description = "ID of the Event Router Bus"
  value       = module.eventrouter.bus_id
}

output "bus_name" {
  description = "Name of the Event Router Bus"
  value       = module.eventrouter.bus_name
}

output "rule_ids" {
  description = "Map of Event Router Rule IDs for all rules"
  value       = module.eventrouter.rule_ids
}

output "rule_names" {
  description = "Map of Event Router Rule names for all rules"
  value       = module.eventrouter.rule_names
}

output "user_events_rule_id" {
  description = "ID of the user events processing rule"
  value       = module.eventrouter.rule_ids["user-events-processor"]
}

output "order_events_rule_id" {
  description = "ID of the order events processing rule"
  value       = module.eventrouter.rule_ids["order-events-processor"]
}

output "audit_events_rule_id" {
  description = "ID of the audit events logging rule"
  value       = module.eventrouter.rule_ids["audit-events-logger"]
}

output "notification_events_rule_id" {
  description = "ID of the notification events queue rule"
  value       = module.eventrouter.rule_ids["notification-events-queue"]
}

output "analytics_events_rule_id" {
  description = "ID of the analytics events stream rule"
  value       = module.eventrouter.rule_ids["analytics-events-stream"]
}

output "connector_id" {
  description = "ID of the Event Router Connector with timer source"
  value       = module.eventrouter.connector_id
}

output "connector_name" {
  description = "Name of the Event Router Connector with timer source"
  value       = module.eventrouter.connector_name
}

output "folder_id" {
  description = "Folder ID used for resources"
  value       = module.eventrouter.folder_id
}

output "connector_type" {
  description = "Type of connector used (timer)"
  value       = "timer"
}

output "rules_count" {
  description = "Number of rules configured"
  value       = length(module.eventrouter.rule_ids)
}

output "rule_target_types" {
  description = "Map of rule names to their target types"
  value = {
    "user-events-processor"     = "function"
    "order-events-processor"    = "container"
    "audit-events-logger"       = "logging"
    "notification-events-queue" = "ymq"
    "analytics-events-stream"   = "yds"
  }
}
