data "yandex_client_config" "client" {}

locals {
  folder_id = var.folder_id == null ? data.yandex_client_config.client.folder_id : var.folder_id
}

resource "yandex_serverless_eventrouter_bus" "main" {
  name        = var.bus_name
  description = var.bus_description
  folder_id   = local.folder_id

  labels = var.bus_labels
}

resource "yandex_serverless_eventrouter_rule" "rules" {
  for_each = { for idx, rule in var.rules : idx => rule }

  name        = each.value.name
  description = each.value.description
  bus_id      = yandex_serverless_eventrouter_bus.main.id
  jq_filter   = each.value.jq_filter

  dynamic "container" {
    for_each = [
      for target in each.value.targets : target.container
      if target.container != null
    ]
    content {
      container_id          = container.value.container_id
      container_revision_id = container.value.container_revision_id
      path                  = container.value.path
      service_account_id    = container.value.service_account_id
    }
  }

  dynamic "function" {
    for_each = [
      for target in each.value.targets : target.function
      if target.function != null
    ]
    content {
      function_id        = function.value.function_id
      function_tag       = function.value.function_tag
      service_account_id = function.value.service_account_id
    }
  }

  dynamic "gateway_websocket_broadcast" {
    for_each = [
      for target in each.value.targets : target.gateway_websocket_broadcast
      if target.gateway_websocket_broadcast != null
    ]
    content {
      gateway_id         = gateway_websocket_broadcast.value.gateway_id
      path               = gateway_websocket_broadcast.value.path
      service_account_id = gateway_websocket_broadcast.value.service_account_id
    }
  }

  dynamic "workflow" {
    for_each = [
      for target in each.value.targets : target.workflow
      if target.workflow != null
    ]
    content {
      workflow_id        = workflow.value.workflow_id
      service_account_id = workflow.value.service_account_id
    }
  }

  dynamic "logging" {
    for_each = [
      for target in each.value.targets : target.logging
      if target.logging != null
    ]
    content {
      log_group_id       = logging.value.log_group_id
      service_account_id = logging.value.service_account_id
    }
  }

  dynamic "yds" {
    for_each = [
      for target in each.value.targets : target.yds
      if target.yds != null
    ]
    content {
      stream_name        = yds.value.stream_name
      database           = yds.value.database
      service_account_id = yds.value.service_account_id
    }
  }

  dynamic "ymq" {
    for_each = [
      for target in each.value.targets : target.ymq
      if target.ymq != null
    ]
    content {
      queue_arn          = ymq.value.queue_arn
      service_account_id = ymq.value.service_account_id
    }
  }

  labels = each.value.labels
}

resource "yandex_serverless_eventrouter_connector" "connectors" {
  for_each = { for idx, connector in var.connectors : idx => connector }

  depends_on          = [yandex_serverless_eventrouter_rule.rules]
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
