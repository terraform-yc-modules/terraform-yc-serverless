module "eventrouter" {
  source = "../../"

  # Event Router Bus configuration
  bus_name        = "example-event-bus"
  bus_description = "Example Event Router Bus for YDS connector and function target"

  # Event Router Rule configuration
  rule_name        = "example-event-rule"
  rule_description = "Example Event Router Rule with function target"
  rule_jq_filter   = ".data"

  # Target type selection - using function
  choosing_eventrouter_rule_target_type = "function"

  # Function target configuration
  rule_function_id                 = "d4es4g1ptv913vpu5u28"
  rule_function_tag                = "$latest"
  rule_function_service_account_id = "aje34qflj6lfp44cmbsq"

  # Event Router Connector configuration
  connector_name        = "example-event-connector"
  connector_description = "Example Event Router Connector with YDS source"

  # Connector type selection - using YDS
  choosing_eventrouter_connector_type = "yds"

  # YDS connector configuration
  connector_yds_stream_name    = "example-stream"
  connector_yds_consumer       = "example-consumer"
  connector_yds_database       = "/ru-central1/b1g3o4minpkuh10pd2rj/etn636at4r5dbg1vvh0u"
  connector_service_account_id = "aje34qflj6lfp44cmbsq"

  # Optional labels
  bus_labels = {
    environment = "example"
    purpose     = "demo"
  }
  rule_labels = {
    environment = "example"
    target      = "function"
  }
  connector_labels = {
    environment = "example"
    source      = "yds"
  }
}
