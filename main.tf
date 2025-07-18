data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
}


# Yandex Cloud Serverless Event Router Bus
resource "yandex_serverless_eventrouter_bus" "main" {
  name        = var.bus_name
  description = var.bus_description
  folder_id   = local.folder_id

  labels = var.bus_labels
}

# Yandex Cloud Serverless Event Router Rule
resource "yandex_serverless_eventrouter_rule" "main" {
  name        = var.rule_name
  description = var.rule_description
  bus_id      = yandex_serverless_eventrouter_bus.main.id

  jq_filter = var.rule_jq_filter

  # Dynamic block for Container target
  dynamic "container" {
    for_each = var.choosing_eventrouter_rule_target_type == "container" ? [1] : []
    content {
      container_id          = var.rule_container_id
      container_revision_id = var.rule_container_revision_id
      path                  = var.rule_container_path
      service_account_id    = var.rule_container_service_account_id
    }
  }

  # Dynamic block for Function target
  dynamic "function" {
    for_each = var.choosing_eventrouter_rule_target_type == "function" ? [1] : []
    content {
      function_id        = var.rule_function_id
      function_tag       = var.rule_function_tag
      service_account_id = var.rule_function_service_account_id
    }
  }

  # Dynamic block for Gateway WebSocket Broadcast target
  dynamic "gateway_websocket_broadcast" {
    for_each = var.choosing_eventrouter_rule_target_type == "gateway_websocket_broadcast" ? [1] : []
    content {
      gateway_id         = var.rule_gateway_websocket_broadcast_gateway_id
      path               = var.rule_gateway_websocket_broadcast_path
      service_account_id = var.rule_gateway_websocket_broadcast_service_account_id
    }
  }

  # Dynamic block for Workflow target
  dynamic "workflow" {
    for_each = var.choosing_eventrouter_rule_target_type == "workflow" ? [1] : []
    content {
      workflow_id        = var.rule_workflow_id
      service_account_id = var.rule_workflow_service_account_id

    }
  }

  # Dynamic block for Logging target
  dynamic "logging" {
    for_each = var.choosing_eventrouter_rule_target_type == "logging" ? [1] : []
    content {
      log_group_id       = var.rule_logging_log_group_id
      service_account_id = var.rule_logging_service_account_id
    }
  }

  # Dynamic block for YDS target
  dynamic "yds" {
    for_each = var.choosing_eventrouter_rule_target_type == "yds" ? [1] : []
    content {
      stream_name        = var.rule_yds_stream_name
      database           = var.rule_yds_database
      service_account_id = var.rule_yds_service_account_id
    }
  }

  # Dynamic block for YMQ target
  dynamic "ymq" {
    for_each = var.choosing_eventrouter_rule_target_type == "ymq" ? [1] : []
    content {
      queue_arn          = var.rule_ymq_queue_arn
      service_account_id = var.rule_ymq_service_account_id
    }
  }

  labels = var.rule_labels
}

# Yandex Cloud Serverless Event Router Connector
resource "yandex_serverless_eventrouter_connector" "main" {
  depends_on          = [yandex_serverless_eventrouter_rule.main]
  name                = var.connector_name
  description         = var.connector_description
  bus_id              = yandex_serverless_eventrouter_bus.main.id
  deletion_protection = var.connector_deletion_protection

  labels = var.connector_labels

  # Dynamic block for Timer connector
  dynamic "timer" {
    for_each = var.choosing_eventrouter_connector_type == "timer" ? [1] : []
    content {
      cron_expression = var.connector_timer_cron_expression
    }
  }

  # Dynamic block for YMQ connector
  dynamic "ymq" {
    for_each = var.choosing_eventrouter_connector_type == "ymq" ? [1] : []
    content {
      queue_arn          = var.connector_queue_arn
      service_account_id = var.connector_service_account
      batch_size         = var.connector_ymq_batch_size
    }
  }

  # Dynamic block for YDS connector
  dynamic "yds" {
    for_each = var.choosing_eventrouter_connector_type == "yds" ? [1] : []
    content {
      stream_name        = var.connector_yds_stream_name
      consumer           = var.connector_yds_consumer
      database           = var.connector_yds_database
      service_account_id = var.connector_service_account_id
    }
  }
}
