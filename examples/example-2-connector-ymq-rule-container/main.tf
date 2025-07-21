module "eventrouter" {
  source = "../../"

  bus_name        = "example-event-bus-ymq"
  bus_description = "Example Event Router Bus for YMQ connector and container target"

  rule_name        = "example-event-rule-container"
  rule_description = "Example Event Router Rule with container target"
  rule_jq_filter   = ".message"

  choosing_eventrouter_rule_target_type = "container"

  rule_container_id                 = "bbaq1kcpp2r0uqfgut5j"
  rule_container_revision_id        = "bbabllu6ck26rehi97ie"
  rule_container_path               = "https://bbaq1kcpp2r0uqfgut5j.containers.yandexcloud.net/"
  rule_container_service_account_id = "aje34qflj6lfp44cmbsq"

  connector_name        = "example-event-connector-ymq"
  connector_description = "Example Event Router Connector with YMQ source"

  choosing_eventrouter_connector_type = "ymq"

  connector_queue_arn       = "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:mq"
  connector_service_account = "aje34qflj6lfp44cmbsq"
  connector_ymq_batch_size  = 5

  bus_labels = {
    environment = "example"
    purpose     = "demo"
    connector   = "ymq"
  }
  rule_labels = {
    environment = "example"
    target      = "container"
  }
  connector_labels = {
    environment = "example"
    source      = "ymq"
  }
}
