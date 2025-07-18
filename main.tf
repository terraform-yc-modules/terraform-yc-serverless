data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
}


# Yandex Cloud Serverless Event Router Bus
resource "yandex_serverless_eventrouter_bus" "main" {
  name        = var.eventrouter_bus_name
  description = var.eventrouter_bus_description
  folder_id   = local.folder_id

  labels = var.eventrouter_bus_labels
}

# Yandex Cloud Serverless Event Router Rule
resource "yandex_serverless_eventrouter_rule" "main" {
  name        = var.eventrouter_rule_name
  description = var.eventrouter_rule_description
  bus_id      = yandex_serverless_eventrouter_bus.main.id

  jq_filter = var.eventrouter_rule_jq_filter

  # Dynamic block for Container target
  dynamic "container" {
    for_each = var.choosing_eventrouter_rule_target_type == "container" ? [1] : []
    content {
      container_id          = var.eventrouter_rule_container_id
      container_revision_id = var.eventrouter_rule_container_revision_id
      path                  = var.eventrouter_rule_container_path
      service_account_id    = var.eventrouter_rule_container_service_account_id
    }
  }

  # Dynamic block for Function target
  dynamic "function" {
    for_each = var.choosing_eventrouter_rule_target_type == "function" ? [1] : []
    content {
      function_id        = var.eventrouter_rule_function_id
      function_tag       = var.eventrouter_rule_function_tag
      service_account_id = var.eventrouter_rule_function_service_account_id
    }
  }

  # Dynamic block for Gateway WebSocket Broadcast target
  dynamic "gateway_websocket_broadcast" {
    for_each = var.choosing_eventrouter_rule_target_type == "gateway_websocket_broadcast" ? [1] : []
    content {
      gateway_id         = var.eventrouter_rule_gateway_websocket_broadcast_gateway_id
      path               = var.eventrouter_rule_gateway_websocket_broadcast_path
      service_account_id = var.eventrouter_rule_gateway_websocket_broadcast_service_account_id
    }
  }

  # Dynamic block for Workflow target
  dynamic "workflow" {
    for_each = var.choosing_eventrouter_rule_target_type == "workflow" ? [1] : []
    content {
      workflow_id        = var.eventrouter_rule_workflow_id
      service_account_id = var.eventrouter_rule_workflow_service_account_id

    }
  }

  # Dynamic block for Logging target
  dynamic "logging" {
    for_each = var.choosing_eventrouter_rule_target_type == "logging" ? [1] : []
    content {
      log_group_id       = var.eventrouter_rule_logging_log_group_id
      service_account_id = var.eventrouter_rule_logging_service_account_id
    }
  }

  # Dynamic block for YDS target
  dynamic "yds" {
    for_each = var.choosing_eventrouter_rule_target_type == "yds" ? [1] : []
    content {
      stream_name        = var.eventrouter_rule_yds_stream_name
      database           = var.eventrouter_rule_yds_database
      service_account_id = var.eventrouter_rule_yds_service_account_id
    }
  }

  # Dynamic block for YMQ target
  dynamic "ymq" {
    for_each = var.choosing_eventrouter_rule_target_type == "ymq" ? [1] : []
    content {
      queue_arn          = var.eventrouter_rule_ymq_queue_arn
      service_account_id = var.eventrouter_rule_ymq_service_account_id
    }
  }

  labels = var.eventrouter_rule_labels
}

# Yandex Cloud Serverless Event Router Connector
resource "yandex_serverless_eventrouter_connector" "main" {
  depends_on          = [yandex_serverless_eventrouter_rule.main]
  name                = var.eventrouter_connector_name
  description         = var.eventrouter_connector_description
  bus_id              = yandex_serverless_eventrouter_bus.main.id
  deletion_protection = var.eventrouter_connector_deletion_protection

  labels = var.eventrouter_connector_labels

  # Dynamic block for Timer connector
  dynamic "timer" {
    for_each = var.choosing_eventrouter_connector_type == "timer" ? [1] : []
    content {
      cron_expression = var.eventrouter_connector_timer_cron_expression
    }
  }

  # Dynamic block for YMQ connector
  dynamic "ymq" {
    for_each = var.choosing_eventrouter_connector_type == "ymq" ? [1] : []
    content {
      queue_arn          = var.eventrouter_connector_queue_arn
      service_account_id = var.eventrouter_connector_service_account
      batch_size         = var.eventrouter_connector_ymq_batch_size
    }
  }

  # Dynamic block for YDS connector
  dynamic "yds" {
    for_each = var.choosing_eventrouter_connector_type == "yds" ? [1] : []
    content {
      stream_name        = var.eventrouter_connector_yds_stream_name
      consumer           = var.eventrouter_connector_yds_consumer
      database           = var.eventrouter_connector_yds_database
      service_account_id = var.eventrouter_connector_service_account_id
    }
  }
}
