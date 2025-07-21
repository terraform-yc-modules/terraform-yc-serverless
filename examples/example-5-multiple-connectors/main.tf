module "eventrouter" {
  source = "../../"

  bus_name        = "example-event-bus-multiple-connectors"
  bus_description = "Example Event Router Bus with multiple connectors demonstration"

  eventrouter_rules = {
    "timer-events-processor" = {
      name        = "timer-events-processor"
      description = "Process timer events with function target"
      jq_filter   = ".source == \"timer\""
      labels = {
        environment = "example"
        target      = "function"
        source      = "timer"
      }
      function = {
        function_id        = "d4es4g1ptv913vpu5u28"
        function_tag       = "$latest"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }

    "ymq-events-processor" = {
      name        = "ymq-events-processor"
      description = "Process YMQ events with container target"
      jq_filter   = ".source == \"ymq\""
      labels = {
        environment = "example"
        target      = "container"
        source      = "ymq"
      }
      container = {
        container_id          = "bbaq1kcpp2r0uqfgut5j"
        container_revision_id = "bbabllu6ck26rehi97ie"
        path                  = "/api/events"
        service_account_id    = "aje34qflj6lfp44cmbsq"
      }
    }

    "yds-events-processor" = {
      name        = "yds-events-processor"
      description = "Process YDS events with logging target"
      jq_filter   = ".source == \"yds\""
      labels = {
        environment = "example"
        target      = "logging"
        source      = "yds"
      }
      logging = {
        log_group_id       = "e23moaejmq8m74tssfu9"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }
  }

  eventrouter_connectors = {
    "timer-connector" = {
      name        = "timer-events-connector"
      description = "Timer-based event connector"
      labels = {
        environment = "example"
        source      = "timer"
        purpose     = "scheduled-events"
      }
      timer = {
        cron_expression = "0 45 16 ? * *"
      }
    }

    "ymq-connector" = {
      name        = "ymq-events-connector"
      description = "YMQ-based event connector"
      labels = {
        environment = "example"
        source      = "ymq"
        purpose     = "queue-events"
      }
      ymq = {
        queue_arn          = "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:mq"
        service_account_id = "aje34qflj6lfp44cmbsq"
        batch_size         = 5
      }
    }

    "yds-connector" = {
      name                = "yds-events-connector"
      description         = "YDS-based event connector"
      deletion_protection = false
      labels = {
        environment = "example"
        source      = "yds"
        purpose     = "stream-events"
      }
      yds = {
        stream_name        = "events-stream"
        consumer           = "events-consumer"
        database           = "/ru-central1/b1g3o4minpkuh10pd2rj/etn636at4r5dbg1vvh0u"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }
  }

  bus_labels = {
    environment = "example"
    purpose     = "multiple-connectors-demo"
  }
}
