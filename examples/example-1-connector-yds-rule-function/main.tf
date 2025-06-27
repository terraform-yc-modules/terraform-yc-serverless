module "eventrouter" {
  source = "../../"

  # Event Router Bus configuration
  eventrouter_bus_name        = "example-event-bus"
  eventrouter_bus_description = "Example Event Router Bus for YDS connector and function target"

  # Event Router Rule configuration
  eventrouter_rule_name        = "example-event-rule"
  eventrouter_rule_description = "Example Event Router Rule with function target"
  eventrouter_rule_jq_filter   = ".data"

  # Target type selection - using function
  choosing_eventrouter_rule_target_type = "function"

  # Function target configuration
  eventrouter_rule_function_id                 = "d4es4g1ptv913vpu5u28"
  eventrouter_rule_function_tag                = "$latest"
  eventrouter_rule_function_service_account_id = "aje34qflj6lfp44cmbsq"

  # Event Router Connector configuration
  eventrouter_connector_name        = "example-event-connector"
  eventrouter_connector_description = "Example Event Router Connector with YDS source"

  # Connector type selection - using YDS
  choosing_eventrouter_connector_type = "yds"

  # YDS connector configuration
  eventrouter_connector_yds_stream_name    = "example-stream"
  eventrouter_connector_yds_consumer       = "example-consumer"
  eventrouter_connector_yds_database       = "/ru-central1/b1g3o4minpkuh10pd2rj/etn636at4r5dbg1vvh0u"
  eventrouter_connector_service_account_id = "aje34qflj6lfp44cmbsq"

  # Optional labels
  eventrouter_bus_labels = {
    environment = "example"
    purpose     = "demo"
  }
  eventrouter_rule_labels = {
    environment = "example"
    target      = "function"
  }
  eventrouter_connector_labels = {
    environment = "example"
    source      = "yds"
  }
}
