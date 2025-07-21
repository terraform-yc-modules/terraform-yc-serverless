module "eventrouter" {
  source = "../../"

  bus_name        = "example-event-bus-timer"
  bus_description = "Example Event Router Bus for timer connector and logging target"

  rule_name        = "example-event-rule-logging"
  rule_description = "Example Event Router Rule with logging target"
  rule_jq_filter   = ".timestamp"

  choosing_eventrouter_rule_target_type = "logging"

  rule_logging_log_group_id       = "e23moaejmq8m74tssfu9"
  rule_logging_service_account_id = "aje34qflj6lfp44cmbsq"

  connector_name        = "example-event-connector-timer"
  connector_description = "Example Event Router Connector with timer source"

  choosing_eventrouter_connector_type = "timer"

  connector_timer_cron_expression = "0 45 16 ? * *"

  bus_labels = {
    environment = "example"
    purpose     = "demo"
    connector   = "timer"
  }
  rule_labels = {
    environment = "example"
    target      = "logging"
  }
  connector_labels = {
    environment = "example"
    source      = "timer"
  }
}
