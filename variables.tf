variable "folder_id" {
  description = "The ID of the folder that the resources belong to."
  type        = string
  default     = null
}

variable "bus_name" {
  description = "Name of the Event Router Bus"
  type        = string
  default     = "event-bus"
}

variable "bus_description" {
  description = "Description of the Event Router Bus"
  type        = string
  default     = "Yandex Cloud EventRouter Bus"
}

variable "bus_labels" {
  description = "Labels for the Event Router Bus"
  type        = map(string)
  default     = {}
}

variable "rules" {
  description = <<EOF
    Example:
    ```
      rules = [
        {
          name        = "mixed-rule"
          description = "Rule for mixed connector types with logging"
          jq_filter   = ""
          
          targets = [
            {
              logging = {
                log_group_id       = yandex_logging_group.example_log_group.id
                service_account_id = yandex_iam_service_account.eventrouter_sa.id
              }
            }
          ]
        }
      ]
    ```
  EOF
  type = list(object({
    name        = string
    description = optional(string, "")
    jq_filter   = optional(string, "")
    labels      = optional(map(string), {})

    targets = list(object({
      container = optional(object({
        container_id          = string
        container_revision_id = optional(string)
        path                  = optional(string)
        service_account_id    = string
      }))

      function = optional(object({
        function_id        = string
        function_tag       = optional(string, "")
        service_account_id = string
      }))

      gateway_websocket_broadcast = optional(object({
        gateway_id         = string
        path               = optional(string)
        service_account_id = string
      }))

      workflow = optional(object({
        workflow_id        = string
        service_account_id = string
      }))

      logging = optional(object({
        log_group_id       = string
        service_account_id = string
      }))

      yds = optional(object({
        stream_name        = string
        database           = string
        service_account_id = string
      }))

      ymq = optional(object({
        queue_arn          = string
        service_account_id = string
      }))
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.rules :
      alltrue([
        for target in rule.targets :
        length([
          for type in [target.container, target.function, target.gateway_websocket_broadcast, target.workflow, target.logging, target.yds, target.ymq] : type
          if type != null
        ]) == 1
      ])
    ])
    error_message = "Each target must have exactly one type specified (container, function, gateway_websocket_broadcast, workflow, logging, yds, or ymq)."
  }
}


variable "connectors" {
  description = <<EOF
    Example:
    ```
      connectors = [
        {
          name        = "timer-connector"
          description = "Single timer-based connector"
          timer = {
            cron_expression = "0 0 12 * * ?"
          }
        }
      ]
    ```
  EOF
  type = list(object({
    name                = string
    description         = optional(string, "")
    deletion_protection = optional(bool, false)
    labels              = optional(map(string), {})

    timer = optional(object({
      cron_expression = string
    }))

    ymq = optional(object({
      queue_arn          = string
      service_account_id = string
      batch_size         = optional(number, 1)
    }))

    yds = optional(object({
      stream_name        = string
      consumer           = string
      database           = string
      service_account_id = string
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for connector in var.connectors :
      length([
        for type in [connector.timer, connector.ymq, connector.yds] : type
        if type != null
      ]) == 1
    ])
    error_message = "Each connector must have exactly one type specified (timer, ymq, or yds)."
  }
}
