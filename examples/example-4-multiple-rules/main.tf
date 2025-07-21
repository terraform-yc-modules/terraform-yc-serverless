module "eventrouter" {
  source = "../../"

  bus_name        = "example-event-bus-multiple-rules"
  bus_description = "Example Event Router Bus with multiple rules demonstration"

  eventrouter_rules = {
    "user-events-processor" = {
      name        = "user-events-processor"
      description = "Process user events with function target"
      jq_filter   = ".eventType == \"user\""
      labels = {
        environment = "example"
        target      = "function"
        event_type  = "user"
      }
      function = {
        function_id        = "d4es4g1ptv913vpu5u28"
        function_tag       = "$latest"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }

    "order-events-processor" = {
      name        = "order-events-processor"
      description = "Process order events with container target"
      jq_filter   = ".eventType == \"order\" and .status == \"created\""
      labels = {
        environment = "example"
        target      = "container"
        event_type  = "order"
      }
      container = {
        container_id          = "bbaq1kcpp2r0uqfgut5j"
        container_revision_id = "bbabllu6ck26rehi97ie"
        path                  = "/api/orders"
        service_account_id    = "aje34qflj6lfp44cmbsq"
      }
    }

    "audit-events-logger" = {
      name        = "audit-events-logger"
      description = "Log all audit events for compliance"
      jq_filter   = ".eventType == \"audit\""
      labels = {
        environment = "example"
        target      = "logging"
        event_type  = "audit"
      }
      logging = {
        log_group_id       = "e23moaejmq8m74tssfu9"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }

    "notification-events-queue" = {
      name        = "notification-events-queue"
      description = "Queue notification events for batch processing"
      jq_filter   = ".eventType == \"notification\""
      labels = {
        environment = "example"
        target      = "ymq"
        event_type  = "notification"
      }
      ymq = {
        queue_arn          = "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:mq"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }

    "analytics-events-stream" = {
      name        = "analytics-events-stream"
      description = "Stream analytics events to data processing pipeline"
      jq_filter   = ".eventType == \"analytics\""
      labels = {
        environment = "example"
        target      = "yds"
        event_type  = "analytics"
      }
      yds = {
        stream_name        = "analytics-stream"
        database           = "/ru-central1/b1g3o4minpkuh10pd2rj/etn636at4r5dbg1vvh0u"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }
  }

  connector_name        = "example-event-connector-multiple-rules"
  connector_description = "Example Event Router Connector for multiple rules demo"

  choosing_eventrouter_connector_type = "timer"

  connector_timer_cron_expression = "0 45 16 ? * *"

  bus_labels = {
    environment = "example"
    purpose     = "multiple-rules-demo"
    connector   = "timer"
  }

  connector_labels = {
    environment = "example"
    source      = "timer"
    purpose     = "multiple-rules-demo"
  }
}
