# Serverless Terraform Module for Yandex.Cloud

## Features

- Create Event Router Connector, Event Router Bus and Event Router Rule (defaults)

## Serverless Event Router Bus definition

First, you need to redefine variables for this module in variables.tf file.

Notes:
- you should use existing service accounts that have right permissions for different resources
- you should have your existing auxiliary resources (for example, cloud functions)
- 4 examples are provided for you: 3 examples with one rule and 1 with multiple rules for eventrouter
- legacy-rule is crucial for backward compatibility (merging legacy variables with new eventrouter_rules)

```
resource "yandex_serverless_eventrouter_bus" "main" {
  name        = var.bus_name
  description = var.bus_description
  folder_id   = local.folder_id

  labels = var.bus_labels
}
```

## Serverless Event Router Connector definition
```
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
```

## Serverless Event Router Rule definition
```
esource "yandex_serverless_eventrouter_rule" "main" {
  for_each = local.merged_rules
  
  name        = each.value.name
  description = each.value.description
  bus_id      = yandex_serverless_eventrouter_bus.main.id
  jq_filter   = each.value.jq_filter

  # Dynamic block for Container target
  dynamic "container" {
    for_each = each.value.container != null ? [each.value.container] : []
    content {
      container_id          = container.value.container_id
      container_revision_id = container.value.container_revision_id
      path                  = container.value.path
      service_account_id    = container.value.service_account_id
    }
  }

  # Dynamic block for Function target
  dynamic "function" {
    for_each = each.value.function != null ? [each.value.function] : []
    content {
      function_id        = function.value.function_id
      function_tag       = function.value.function_tag
      service_account_id = function.value.service_account_id
    }
  }

  # Dynamic block for Gateway WebSocket Broadcast target
  dynamic "gateway_websocket_broadcast" {
    for_each = each.value.gateway_websocket_broadcast != null ? [each.value.gateway_websocket_broadcast] : []
    content {
      gateway_id         = gateway_websocket_broadcast.value.gateway_id
      path               = gateway_websocket_broadcast.value.path
      service_account_id = gateway_websocket_broadcast.value.service_account_id
    }
  }

  # Dynamic block for Workflow target
  dynamic "workflow" {
    for_each = each.value.workflow != null ? [each.value.workflow] : []
    content {
      workflow_id        = workflow.value.workflow_id
      service_account_id = workflow.value.service_account_id
    }
  }

  # Dynamic block for Logging target
  dynamic "logging" {
    for_each = each.value.logging != null ? [each.value.logging] : []
    content {
      log_group_id       = logging.value.log_group_id
      service_account_id = logging.value.service_account_id
    }
  }

  # Dynamic block for YDS target
  dynamic "yds" {
    for_each = each.value.yds != null ? [each.value.yds] : []
    content {
      stream_name        = yds.value.stream_name
      database           = yds.value.database
      service_account_id = yds.value.service_account_id
    }
  }

  # Dynamic block for YMQ target
  dynamic "ymq" {
    for_each = each.value.ymq != null ? [each.value.ymq] : []
    content {
      queue_arn          = ymq.value.queue_arn
      service_account_id = ymq.value.service_account_id
    }
  }

  labels = each.value.labels
}
```

### Example Usage

```
module "eventrouter" {
  source = "../../"

  # Event Router Bus configuration
  bus_name        = "example-event-bus-multiple-rules"
  bus_description = "Example Event Router Bus with multiple rules demonstration"

  # Multiple Event Router Rules configuration using the new eventrouter_rules variable
  eventrouter_rules = {
    # Rule 1: Function target for processing user events
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

    # Rule 2: Container target for processing order events
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

    # Rule 3: Logging target for audit events
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

    # Rule 4: YMQ target for notification events
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

    # Rule 5: YDS target for analytics events
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

  # Event Router Connector configuration
  connector_name        = "example-event-connector-multiple-rules"
  connector_description = "Example Event Router Connector for multiple rules demo"

  # Connector type selection - using timer for regular event generation
  choosing_eventrouter_connector_type = "timer"

  # Timer connector configuration - trigger every 5 minutes for demo
  connector_timer_cron_expression = "0 45 16 ? * *"

  # Optional labels
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
```

## Configure Terraform for Yandex Cloud

- Install [YC CLI](https://cloud.yandex.com/docs/cli/quickstart)
- Add environment variables for terraform authentication in Yandex Cloud

```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | > 3.3 |
| <a name="requirement_time"></a> [time](#requirement\_time) | > 0.9 |
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.108 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.146.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_serverless_eventrouter_bus.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/serverless_eventrouter_bus) | resource |
| [yandex_serverless_eventrouter_connector.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/serverless_eventrouter_connector) | resource |
| [yandex_serverless_eventrouter_rule.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/serverless_eventrouter_rule) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bus_description"></a> [bus\_description](#input\_bus\_description) | Description of the Event Router Bus | `string` | `"Yandex Cloud EventRouter Bus"` | no |
| <a name="input_bus_labels"></a> [bus\_labels](#input\_bus\_labels) | Labels for the Event Router Bus | `map(string)` | `{}` | no |
| <a name="input_bus_name"></a> [bus\_name](#input\_bus\_name) | Name of the Event Router Bus | `string` | `"event-bus"` | no |
| <a name="input_choosing_eventrouter_connector_type"></a> [choosing\_eventrouter\_connector\_type](#input\_choosing\_eventrouter\_connector\_type) | Type of the Event Router Connector source (timer, ymq, yds) | `string` | `"ymq"` | no |
| <a name="input_choosing_eventrouter_rule_target_type"></a> [choosing\_eventrouter\_rule\_target\_type](#input\_choosing\_eventrouter\_rule\_target\_type) | [DEPRECATED] Use eventrouter\_rules instead. Type of the Event Router Rule target | `string` | `null` | no |
| <a name="input_connector_deletion_protection"></a> [connector\_deletion\_protection](#input\_connector\_deletion\_protection) | Deletion protection for the Event Router Connector | `bool` | `false` | no |
| <a name="input_connector_description"></a> [connector\_description](#input\_connector\_description) | Description of the Event Router Connector | `string` | `"Yandex Cloud EventRouter Connector"` | no |
| <a name="input_connector_labels"></a> [connector\_labels](#input\_connector\_labels) | Labels for the Event Router Connector | `map(string)` | `{}` | no |
| <a name="input_connector_name"></a> [connector\_name](#input\_connector\_name) | Name of the Event Router Connector | `string` | `"event-connector"` | no |
| <a name="input_connector_queue_arn"></a> [connector\_queue\_arn](#input\_connector\_queue\_arn) | Event Router Queue ARN | `string` | `"yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:new-mq"` | no |
| <a name="input_connector_service_account"></a> [connector\_service\_account](#input\_connector\_service\_account) | Service account which has read access to the queue | `string` | `"aje34qflj6lfp44cmbsq"` | no |
| <a name="input_connector_service_account_id"></a> [connector\_service\_account\_id](#input\_connector\_service\_account\_id) | Service account which has read permission on the stream | `string` | `"aje34qflj6lfp44cmbsq"` | no |
| <a name="input_connector_timer_cron_expression"></a> [connector\_timer\_cron\_expression](#input\_connector\_timer\_cron\_expression) | Cron expression for timer connector | `string` | `"0 45 16 ? * *"` | no |
| <a name="input_connector_yds_consumer"></a> [connector\_yds\_consumer](#input\_connector\_yds\_consumer) | YDS consumer name for the connector | `string` | `"ydb-new"` | no |
| <a name="input_connector_yds_database"></a> [connector\_yds\_database](#input\_connector\_yds\_database) | YDS database for the connector | `string` | `"/ru-central1/b1g3o4minpkuh10pd2rj/etn636at4r5dbg1vvh0u"` | no |
| <a name="input_connector_yds_stream_name"></a> [connector\_yds\_stream\_name](#input\_connector\_yds\_stream\_name) | YDS stream name for the connector | `string` | `"ydb-new"` | no |
| <a name="input_connector_ymq_batch_size"></a> [connector\_ymq\_batch\_size](#input\_connector\_ymq\_batch\_size) | Batch size for YMQ connector | `number` | `1` | no |
| <a name="input_eventrouter_rules"></a> [eventrouter\_rules](#input\_eventrouter\_rules) | Map of Event Router Rules configuration | <pre>map(object({<br/>    name        = string<br/>    description = optional(string, "Yandex Cloud EventRouter Rule")<br/>    jq_filter   = optional(string, "")<br/>    labels      = optional(map(string), {})<br/><br/>    # Target configuration - only one target type should be specified per rule<br/>    container = optional(object({<br/>      container_id          = string<br/>      container_revision_id = optional(string)<br/>      path                  = optional(string)<br/>      service_account_id    = string<br/>    }))<br/><br/>    function = optional(object({<br/>      function_id        = string<br/>      function_tag       = optional(string, "$latest")<br/>      service_account_id = string<br/>    }))<br/><br/>    gateway_websocket_broadcast = optional(object({<br/>      gateway_id         = string<br/>      path               = optional(string)<br/>      service_account_id = string<br/>    }))<br/><br/>    workflow = optional(object({<br/>      workflow_id        = string<br/>      service_account_id = string<br/>    }))<br/><br/>    logging = optional(object({<br/>      log_group_id       = string<br/>      service_account_id = string<br/>    }))<br/><br/>    yds = optional(object({<br/>      stream_name        = string<br/>      database           = string<br/>      service_account_id = string<br/>    }))<br/><br/>    ymq = optional(object({<br/>      queue_arn          = string<br/>      service_account_id = string<br/>    }))<br/>  }))</pre> | <pre>{<br/>  "default-rule": {<br/>    "description": "Yandex Cloud EventRouter Rule",<br/>    "jq_filter": "",<br/>    "labels": {},<br/>    "name": "event-rule",<br/>    "ymq": {<br/>      "queue_arn": "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:mq",<br/>      "service_account_id": "aje34qflj6lfp44cmbsq"<br/>    }<br/>  }<br/>}</pre> | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of the folder that the resources belong to. | `string` | `null` | no |
| <a name="input_rule_container_id"></a> [rule\_container\_id](#input\_rule\_container\_id) | [DEPRECATED] Use eventrouter\_rules instead. Container ID for the Event Router Rule container target | `string` | `null` | no |
| <a name="input_rule_container_path"></a> [rule\_container\_path](#input\_rule\_container\_path) | [DEPRECATED] Use eventrouter\_rules instead. Container path for the Event Router Rule container target | `string` | `null` | no |
| <a name="input_rule_container_revision_id"></a> [rule\_container\_revision\_id](#input\_rule\_container\_revision\_id) | [DEPRECATED] Use eventrouter\_rules instead. Container Revision ID for the Event Router Rule container target | `string` | `null` | no |
| <a name="input_rule_container_service_account_id"></a> [rule\_container\_service\_account\_id](#input\_rule\_container\_service\_account\_id) | [DEPRECATED] Use eventrouter\_rules instead. Service account which should be used to call a container | `string` | `null` | no |
| <a name="input_rule_description"></a> [rule\_description](#input\_rule\_description) | [DEPRECATED] Use eventrouter\_rules instead. Description of the Event Router Rule | `string` | `null` | no |
| <a name="input_rule_function_id"></a> [rule\_function\_id](#input\_rule\_function\_id) | [DEPRECATED] Use eventrouter\_rules instead. Function ID for the Event Router Rule function target | `string` | `null` | no |
| <a name="input_rule_function_service_account_id"></a> [rule\_function\_service\_account\_id](#input\_rule\_function\_service\_account\_id) | [DEPRECATED] Use eventrouter\_rules instead. Service account which has call permission on the function | `string` | `null` | no |
| <a name="input_rule_function_tag"></a> [rule\_function\_tag](#input\_rule\_function\_tag) | [DEPRECATED] Use eventrouter\_rules instead. Function tag for the Event Router Rule function target | `string` | `null` | no |
| <a name="input_rule_gateway_websocket_broadcast_gateway_id"></a> [rule\_gateway\_websocket\_broadcast\_gateway\_id](#input\_rule\_gateway\_websocket\_broadcast\_gateway\_id) | [DEPRECATED] Use eventrouter\_rules instead. Gateway ID for the Event Router Rule gateway websocket broadcast target | `string` | `null` | no |
| <a name="input_rule_gateway_websocket_broadcast_path"></a> [rule\_gateway\_websocket\_broadcast\_path](#input\_rule\_gateway\_websocket\_broadcast\_path) | [DEPRECATED] Use eventrouter\_rules instead. Path for the Event Router Rule gateway websocket broadcast target | `string` | `null` | no |
| <a name="input_rule_gateway_websocket_broadcast_service_account_id"></a> [rule\_gateway\_websocket\_broadcast\_service\_account\_id](#input\_rule\_gateway\_websocket\_broadcast\_service\_account\_id) | [DEPRECATED] Use eventrouter\_rules instead. Service account which has permission for writing to websockets | `string` | `null` | no |
| <a name="input_rule_jq_filter"></a> [rule\_jq\_filter](#input\_rule\_jq\_filter) | [DEPRECATED] Use eventrouter\_rules instead. JQ filter for the Event Router Rule | `string` | `null` | no |
| <a name="input_rule_labels"></a> [rule\_labels](#input\_rule\_labels) | [DEPRECATED] Use eventrouter\_rules instead. Labels for the Event Router Rule | `map(string)` | `null` | no |
| <a name="input_rule_logging_log_group_id"></a> [rule\_logging\_log\_group\_id](#input\_rule\_logging\_log\_group\_id) | [DEPRECATED] Use eventrouter\_rules instead. Log group ID for the Event Router Rule logging target | `string` | `null` | no |
| <a name="input_rule_logging_service_account_id"></a> [rule\_logging\_service\_account\_id](#input\_rule\_logging\_service\_account\_id) | [DEPRECATED] Use eventrouter\_rules instead. Service account which has permission for writing logs | `string` | `null` | no |
| <a name="input_rule_name"></a> [rule\_name](#input\_rule\_name) | [DEPRECATED] Use eventrouter\_rules instead. Name of the Event Router Rule | `string` | `null` | no |
| <a name="input_rule_workflow_id"></a> [rule\_workflow\_id](#input\_rule\_workflow\_id) | [DEPRECATED] Use eventrouter\_rules instead. Workflow ID for the Event Router Rule workflow target | `string` | `null` | no |
| <a name="input_rule_workflow_service_account_id"></a> [rule\_workflow\_service\_account\_id](#input\_rule\_workflow\_service\_account\_id) | [DEPRECATED] Use eventrouter\_rules instead. Service account which should be used to start workflow | `string` | `null` | no |
| <a name="input_rule_yds_database"></a> [rule\_yds\_database](#input\_rule\_yds\_database) | [DEPRECATED] Use eventrouter\_rules instead. YDS database for the Event Router Rule YDS target | `string` | `null` | no |
| <a name="input_rule_yds_service_account_id"></a> [rule\_yds\_service\_account\_id](#input\_rule\_yds\_service\_account\_id) | [DEPRECATED] Use eventrouter\_rules instead. Service account, which has write permission on the stream | `string` | `null` | no |
| <a name="input_rule_yds_stream_name"></a> [rule\_yds\_stream\_name](#input\_rule\_yds\_stream\_name) | [DEPRECATED] Use eventrouter\_rules instead. YDS stream name for the Event Router Rule YDS target | `string` | `null` | no |
| <a name="input_rule_ymq_queue_arn"></a> [rule\_ymq\_queue\_arn](#input\_rule\_ymq\_queue\_arn) | [DEPRECATED] Use eventrouter\_rules instead. YMQ queue ARN for the Event Router Rule YMQ target | `string` | `null` | no |
| <a name="input_rule_ymq_service_account_id"></a> [rule\_ymq\_service\_account\_id](#input\_rule\_ymq\_service\_account\_id) | [DEPRECATED] Use eventrouter\_rules instead. Service account which has write access to the queue | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bus_id"></a> [bus\_id](#output\_bus\_id) | ID of the Event Router Bus |
| <a name="output_bus_name"></a> [bus\_name](#output\_bus\_name) | Name of the Event Router Bus |
| <a name="output_connector_id"></a> [connector\_id](#output\_connector\_id) | ID of the Event Router Connector |
| <a name="output_connector_name"></a> [connector\_name](#output\_connector\_name) | Name of the Event Router Connector |
| <a name="output_folder_id"></a> [folder\_id](#output\_folder\_id) | Folder ID used for resources |
| <a name="output_rule_id"></a> [rule\_id](#output\_rule\_id) | [DEPRECATED] Use rule\_ids instead. ID of the first Event Router Rule |
| <a name="output_rule_ids"></a> [rule\_ids](#output\_rule\_ids) | Map of Event Router Rule IDs |
| <a name="output_rule_name"></a> [rule\_name](#output\_rule\_name) | [DEPRECATED] Use rule\_names instead. Name of the first Event Router Rule |
| <a name="output_rule_names"></a> [rule\_names](#output\_rule\_names) | Map of Event Router Rule names |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
