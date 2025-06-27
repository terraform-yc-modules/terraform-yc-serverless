module "eventrouter" {
  source = "../../"

  # Event Router Bus configuration
  eventrouter_bus_name        = "example-event-bus-ymq"
  eventrouter_bus_description = "Example Event Router Bus for YMQ connector and container target"

  # Event Router Rule configuration
  eventrouter_rule_name        = "example-event-rule-container"
  eventrouter_rule_description = "Example Event Router Rule with container target"
  eventrouter_rule_jq_filter   = ".message"

  # Target type selection - using container
  choosing_eventrouter_rule_target_type = "container"

  # Container target configuration
  eventrouter_rule_container_id                 = "bbaq1kcpp2r0uqfgut5j"
  eventrouter_rule_container_revision_id        = "bbabllu6ck26rehi97ie"
  eventrouter_rule_container_path               = "https://bbaq1kcpp2r0uqfgut5j.containers.yandexcloud.net/"
  eventrouter_rule_container_service_account_id = "aje34qflj6lfp44cmbsq"

  # Event Router Connector configuration
  eventrouter_connector_name        = "example-event-connector-ymq"
  eventrouter_connector_description = "Example Event Router Connector with YMQ source"

  # Connector type selection - using YMQ
  choosing_eventrouter_connector_type = "ymq"

  # YMQ connector configuration
  eventrouter_connector_queue_arn       = "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:mq"
  eventrouter_connector_service_account = "aje34qflj6lfp44cmbsq"
  eventrouter_connector_ymq_batch_size  = 5

  # Optional labels
  eventrouter_bus_labels = {
    environment = "example"
    purpose     = "demo"
    connector   = "ymq"
  }
  eventrouter_rule_labels = {
    environment = "example"
    target      = "container"
  }
  eventrouter_connector_labels = {
    environment = "example"
    source      = "ymq"
  }
}
