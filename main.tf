data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id

  merged_connectors = var.connector_name != "event-connector" || var.choosing_eventrouter_connector_type != "ymq" ? merge(var.eventrouter_connectors, {
    "legacy-connector" = {
      name                = var.connector_name
      description         = var.connector_description
      deletion_protection = var.connector_deletion_protection
      labels              = var.connector_labels

      timer = var.choosing_eventrouter_connector_type == "timer" ? {
        cron_expression = var.connector_timer_cron_expression
      } : null

      ymq = var.choosing_eventrouter_connector_type == "ymq" ? {
        queue_arn          = var.connector_queue_arn
        service_account_id = var.connector_service_account
        batch_size         = var.connector_ymq_batch_size
      } : null

      yds = var.choosing_eventrouter_connector_type == "yds" ? {
        stream_name        = var.connector_yds_stream_name
        consumer           = var.connector_yds_consumer
        database           = var.connector_yds_database
        service_account_id = var.connector_service_account_id
      } : null
    }
  }) : var.eventrouter_connectors

  merged_rules = var.rule_name != null ? merge(var.eventrouter_rules, {
    "legacy-rule" = {
      name        = var.rule_name
      description = var.rule_description != null ? var.rule_description : "Yandex Cloud EventRouter Rule"
      jq_filter   = var.rule_jq_filter != null ? var.rule_jq_filter : ""
      labels      = var.rule_labels != null ? var.rule_labels : {}

      container = var.choosing_eventrouter_rule_target_type == "container" ? {
        container_id          = var.rule_container_id
        container_revision_id = var.rule_container_revision_id
        path                  = var.rule_container_path
        service_account_id    = var.rule_container_service_account_id
      } : null

      function = var.choosing_eventrouter_rule_target_type == "function" ? {
        function_id        = var.rule_function_id
        function_tag       = var.rule_function_tag
        service_account_id = var.rule_function_service_account_id
      } : null

      gateway_websocket_broadcast = var.choosing_eventrouter_rule_target_type == "gateway_websocket_broadcast" ? {
        gateway_id         = var.rule_gateway_websocket_broadcast_gateway_id
        path               = var.rule_gateway_websocket_broadcast_path
        service_account_id = var.rule_gateway_websocket_broadcast_service_account_id
      } : null

      workflow = var.choosing_eventrouter_rule_target_type == "workflow" ? {
        workflow_id        = var.rule_workflow_id
        service_account_id = var.rule_workflow_service_account_id
      } : null

      logging = var.choosing_eventrouter_rule_target_type == "logging" ? {
        log_group_id       = var.rule_logging_log_group_id
        service_account_id = var.rule_logging_service_account_id
      } : null

      yds = var.choosing_eventrouter_rule_target_type == "yds" ? {
        stream_name        = var.rule_yds_stream_name
        database           = var.rule_yds_database
        service_account_id = var.rule_yds_service_account_id
      } : null

      ymq = var.choosing_eventrouter_rule_target_type == "ymq" ? {
        queue_arn          = var.rule_ymq_queue_arn
        service_account_id = var.rule_ymq_service_account_id
      } : null
    }
  }) : var.eventrouter_rules
}

resource "yandex_serverless_eventrouter_bus" "main" {
  name        = var.bus_name
  description = var.bus_description
  folder_id   = local.folder_id

  labels = var.bus_labels
}

resource "yandex_serverless_eventrouter_rule" "main" {
  for_each = local.merged_rules

  name        = each.value.name
  description = each.value.description
  bus_id      = yandex_serverless_eventrouter_bus.main.id
  jq_filter   = each.value.jq_filter

  dynamic "container" {
    for_each = each.value.container != null ? [each.value.container] : []
    content {
      container_id          = container.value.container_id
      container_revision_id = container.value.container_revision_id
      path                  = container.value.path
      service_account_id    = container.value.service_account_id
    }
  }

  dynamic "function" {
    for_each = each.value.function != null ? [each.value.function] : []
    content {
      function_id        = function.value.function_id
      function_tag       = function.value.function_tag
      service_account_id = function.value.service_account_id
    }
  }

  dynamic "gateway_websocket_broadcast" {
    for_each = each.value.gateway_websocket_broadcast != null ? [each.value.gateway_websocket_broadcast] : []
    content {
      gateway_id         = gateway_websocket_broadcast.value.gateway_id
      path               = gateway_websocket_broadcast.value.path
      service_account_id = gateway_websocket_broadcast.value.service_account_id
    }
  }

  dynamic "workflow" {
    for_each = each.value.workflow != null ? [each.value.workflow] : []
    content {
      workflow_id        = workflow.value.workflow_id
      service_account_id = workflow.value.service_account_id
    }
  }

  dynamic "logging" {
    for_each = each.value.logging != null ? [each.value.logging] : []
    content {
      log_group_id       = logging.value.log_group_id
      service_account_id = logging.value.service_account_id
    }
  }

  dynamic "yds" {
    for_each = each.value.yds != null ? [each.value.yds] : []
    content {
      stream_name        = yds.value.stream_name
      database           = yds.value.database
      service_account_id = yds.value.service_account_id
    }
  }

  dynamic "ymq" {
    for_each = each.value.ymq != null ? [each.value.ymq] : []
    content {
      queue_arn          = ymq.value.queue_arn
      service_account_id = ymq.value.service_account_id
    }
  }

  labels = each.value.labels
}

resource "yandex_serverless_eventrouter_connector" "main" {
  for_each = local.merged_connectors

  depends_on          = [yandex_serverless_eventrouter_rule.main]
  name                = each.value.name
  description         = each.value.description
  bus_id              = yandex_serverless_eventrouter_bus.main.id
  deletion_protection = each.value.deletion_protection

  labels = each.value.labels

  dynamic "timer" {
    for_each = each.value.timer != null ? [each.value.timer] : []
    content {
      cron_expression = timer.value.cron_expression
    }
  }

  dynamic "ymq" {
    for_each = each.value.ymq != null ? [each.value.ymq] : []
    content {
      queue_arn          = ymq.value.queue_arn
      service_account_id = ymq.value.service_account_id
      batch_size         = ymq.value.batch_size
    }
  }

  dynamic "yds" {
    for_each = each.value.yds != null ? [each.value.yds] : []
    content {
      stream_name        = yds.value.stream_name
      consumer           = yds.value.consumer
      database           = yds.value.database
      service_account_id = yds.value.service_account_id
    }
  }
}
