module "eventrouter" {
  source = "../../"

  # Event Router Bus configuration
  eventrouter_bus_name        = "example-event-bus-timer"
  eventrouter_bus_description = "Example Event Router Bus for timer connector and logging target"

  # Event Router Rule configuration
  eventrouter_rule_name        = "example-event-rule-logging"
  eventrouter_rule_description = "Example Event Router Rule with logging target"
  eventrouter_rule_jq_filter   = ".timestamp"

  # Target type selection - using logging
  choosing_eventrouter_rule_target_type = "logging"

  # Logging target configuration
  eventrouter_rule_logging_log_group_id       = "e23moaejmq8m74tssfu9"
  eventrouter_rule_logging_service_account_id = "aje34qflj6lfp44cmbsq"

  # Event Router Connector configuration
  eventrouter_connector_name        = "example-event-connector-timer"
  eventrouter_connector_description = "Example Event Router Connector with timer source"

  # Connector type selection - using timer
  choosing_eventrouter_connector_type = "timer"

  # Timer connector configuration
  eventrouter_connector_timer_cron_expression = "0 45 16 ? * *"

  # Optional labels
  eventrouter_bus_labels = {
    environment = "example"
    purpose     = "demo"
    connector   = "timer"
  }
  eventrouter_rule_labels = {
    environment = "example"
    target      = "logging"
  }
  eventrouter_connector_labels = {
    environment = "example"
    source      = "timer"
  }
}
