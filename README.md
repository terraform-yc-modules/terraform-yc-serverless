# Serverless Terraform Module for Yandex.Cloud

## Features

- Create Event Router Bus
- Create Event Router Connector of three types: timer, ymq, yds
- Create Event Router Rule (or Rules) of seven types: container, function, gateway_websocket_broadcast, workflow, logging, yds, ymq
- Easy to use in other resources via outputs

## Serverless Event Router Bus definition

Notes:
- service accounts with right permissions for different resources are created for you in the [examples](https://github.com/terraform-yc-modules/terraform-yc-serverless/tree/master/examples)
- 4 examples are provided for you: 1 with multiple connectors, 1 with multiple targets for rule, 1 with one rule and one connector, 1 with multiple rules

## Serverless Event Router Connector definition

Notes:
- connector must be of only one type (timer, ymq or yds)
- you can use whether one connector or multiple ones

## Serverless Event Router Rule definition

Notes:
- you can use whether one rule or multiple ones
- you can define multiple targets for each rule

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
| <a name="requirement_yandex"></a> [yandex](#requirement\_yandex) | >= 0.108 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | 0.147.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_serverless_eventrouter_bus.main](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/serverless_eventrouter_bus) | resource |
| [yandex_serverless_eventrouter_connector.connectors](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/serverless_eventrouter_connector) | resource |
| [yandex_serverless_eventrouter_rule.rules](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/serverless_eventrouter_rule) | resource |
| [yandex_client_config.client](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bus_description"></a> [bus\_description](#input\_bus\_description) | Description of the Event Router Bus | `string` | `"Yandex Cloud EventRouter Bus"` | no |
| <a name="input_bus_labels"></a> [bus\_labels](#input\_bus\_labels) | Labels for the Event Router Bus | `map(string)` | `{}` | no |
| <a name="input_bus_name"></a> [bus\_name](#input\_bus\_name) | Name of the Event Router Bus | `string` | `"event-bus"` | no |
| <a name="input_connectors"></a> [connectors](#input\_connectors) | Example:<pre>connectors = [<br/>        {<br/>          name        = "timer-connector"<br/>          description = "Single timer-based connector"<br/>          timer = {<br/>            cron_expression = "0 0 12 * * ?"<br/>          }<br/>        }<br/>      ]</pre> | <pre>list(object({<br/>    name                = string<br/>    description         = optional(string, "")<br/>    deletion_protection = optional(bool, false)<br/>    labels              = optional(map(string), {})<br/><br/>    timer = optional(object({<br/>      cron_expression = string<br/>    }))<br/><br/>    ymq = optional(object({<br/>      queue_arn          = string<br/>      service_account_id = string<br/>      batch_size         = optional(number, 1)<br/>    }))<br/><br/>    yds = optional(object({<br/>      stream_name        = string<br/>      consumer           = string<br/>      database           = string<br/>      service_account_id = string<br/>    }))<br/>  }))</pre> | `[]` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of the folder that the resources belong to. | `string` | `null` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | Example:<pre>rules = [<br/>        {<br/>          name        = "mixed-rule"<br/>          description = "Rule for mixed connector types with logging"<br/>          jq_filter   = ""<br/>          <br/>          targets = [<br/>            {<br/>              logging = {<br/>                log_group_id       = yandex_logging_group.example_log_group.id<br/>                service_account_id = yandex_iam_service_account.eventrouter_sa.id<br/>              }<br/>            }<br/>          ]<br/>        }<br/>      ]</pre> | <pre>list(object({<br/>    name        = string<br/>    description = optional(string, "")<br/>    jq_filter   = optional(string, "")<br/>    labels      = optional(map(string), {})<br/><br/>    targets = list(object({<br/>      container = optional(object({<br/>        container_id          = string<br/>        container_revision_id = optional(string)<br/>        path                  = optional(string)<br/>        service_account_id    = string<br/>      }))<br/><br/>      function = optional(object({<br/>        function_id        = string<br/>        function_tag       = optional(string, "")<br/>        service_account_id = string<br/>      }))<br/><br/>      gateway_websocket_broadcast = optional(object({<br/>        gateway_id         = string<br/>        path               = optional(string)<br/>        service_account_id = string<br/>      }))<br/><br/>      workflow = optional(object({<br/>        workflow_id        = string<br/>        service_account_id = string<br/>      }))<br/><br/>      logging = optional(object({<br/>        log_group_id       = string<br/>        service_account_id = string<br/>      }))<br/><br/>      yds = optional(object({<br/>        stream_name        = string<br/>        database           = string<br/>        service_account_id = string<br/>      }))<br/><br/>      ymq = optional(object({<br/>        queue_arn          = string<br/>        service_account_id = string<br/>      }))<br/>    }))<br/>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bus_id"></a> [bus\_id](#output\_bus\_id) | ID of the Event Router Bus |
| <a name="output_bus_name"></a> [bus\_name](#output\_bus\_name) | Name of the Event Router Bus |
| <a name="output_connector_ids"></a> [connector\_ids](#output\_connector\_ids) | IDs of the Event Router Connectors |
| <a name="output_connector_names"></a> [connector\_names](#output\_connector\_names) | Names of the Event Router Connectors |
| <a name="output_rule_ids"></a> [rule\_ids](#output\_rule\_ids) | IDs of the Event Router Rules |
| <a name="output_rule_names"></a> [rule\_names](#output\_rule\_names) | Names of the Event Router Rules |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
