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

variable "eventrouter_rules" {
  description = "Map of Event Router Rules configuration"
  type = map(object({
    name        = string
    description = optional(string, "Yandex Cloud EventRouter Rule")
    jq_filter   = optional(string, "")
    labels      = optional(map(string), {})

    container = optional(object({
      container_id          = string
      container_revision_id = optional(string)
      path                  = optional(string)
      service_account_id    = string
    }))

    function = optional(object({
      function_id        = string
      function_tag       = optional(string, "$latest")
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
  default = {
    "default-rule" = {
      name        = "event-rule"
      description = "Yandex Cloud EventRouter Rule"
      jq_filter   = ""
      labels      = {}
      ymq = {
        queue_arn          = "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:mq"
        service_account_id = "aje34qflj6lfp44cmbsq"
      }
    }
  }

  validation {
    condition = alltrue([
      for rule_key, rule in var.eventrouter_rules : (
        length([
          for target in [rule.container, rule.function, rule.gateway_websocket_broadcast, rule.workflow, rule.logging, rule.yds, rule.ymq] : target
          if target != null
        ]) == 1
      )
    ])
    error_message = "Each rule must have exactly one target type specified (container, function, gateway_websocket_broadcast, workflow, logging, yds, or ymq)."
  }
}

variable "rule_name" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Name of the Event Router Rule"
  type        = string
  default     = null
}

variable "rule_description" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Description of the Event Router Rule"
  type        = string
  default     = null
}

variable "rule_jq_filter" {
  description = "[DEPRECATED] Use eventrouter_rules instead. JQ filter for the Event Router Rule"
  type        = string
  default     = null
}

variable "rule_labels" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Labels for the Event Router Rule"
  type        = map(string)
  default     = null
}

variable "choosing_eventrouter_rule_target_type" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Type of the Event Router Rule target"
  type        = string
  default     = null
}

variable "rule_container_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Container ID for the Event Router Rule container target"
  type        = string
  default     = null
}

variable "rule_container_revision_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Container Revision ID for the Event Router Rule container target"
  type        = string
  default     = null
}

variable "rule_container_path" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Container path for the Event Router Rule container target"
  type        = string
  default     = null
}

variable "rule_container_service_account_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Service account which should be used to call a container"
  type        = string
  default     = null
}

variable "rule_function_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Function ID for the Event Router Rule function target"
  type        = string
  default     = null
}

variable "rule_function_tag" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Function tag for the Event Router Rule function target"
  type        = string
  default     = null
}

variable "rule_function_service_account_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Service account which has call permission on the function"
  type        = string
  default     = null
}

variable "rule_gateway_websocket_broadcast_gateway_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Gateway ID for the Event Router Rule gateway websocket broadcast target"
  type        = string
  default     = null
}

variable "rule_gateway_websocket_broadcast_path" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Path for the Event Router Rule gateway websocket broadcast target"
  type        = string
  default     = null
}

variable "rule_gateway_websocket_broadcast_service_account_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Service account which has permission for writing to websockets"
  type        = string
  default     = null
}

variable "rule_workflow_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Workflow ID for the Event Router Rule workflow target"
  type        = string
  default     = null
}

variable "rule_workflow_service_account_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Service account which should be used to start workflow"
  type        = string
  default     = null
}

variable "rule_logging_log_group_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Log group ID for the Event Router Rule logging target"
  type        = string
  default     = null
}

variable "rule_logging_service_account_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Service account which has permission for writing logs"
  type        = string
  default     = null
}

variable "rule_yds_stream_name" {
  description = "[DEPRECATED] Use eventrouter_rules instead. YDS stream name for the Event Router Rule YDS target"
  type        = string
  default     = null
}

variable "rule_yds_database" {
  description = "[DEPRECATED] Use eventrouter_rules instead. YDS database for the Event Router Rule YDS target"
  type        = string
  default     = null
}

variable "rule_yds_service_account_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Service account, which has write permission on the stream"
  type        = string
  default     = null
}

variable "rule_ymq_queue_arn" {
  description = "[DEPRECATED] Use eventrouter_rules instead. YMQ queue ARN for the Event Router Rule YMQ target"
  type        = string
  default     = null
}

variable "rule_ymq_service_account_id" {
  description = "[DEPRECATED] Use eventrouter_rules instead. Service account which has write access to the queue"
  type        = string
  default     = null
}

variable "connector_name" {
  description = "Name of the Event Router Connector"
  type        = string
  default     = "event-connector"
}

variable "connector_description" {
  description = "Description of the Event Router Connector"
  type        = string
  default     = "Yandex Cloud EventRouter Connector"
}

variable "connector_deletion_protection" {
  description = "Deletion protection for the Event Router Connector"
  type        = bool
  default     = false
}

variable "connector_labels" {
  description = "Labels for the Event Router Connector"
  type        = map(string)
  default     = {}
}

variable "connector_queue_arn" {
  description = "Event Router Queue ARN"
  type        = string
  default     = "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:new-mq"
}

variable "connector_service_account" {
  description = "Service account which has read access to the queue"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

variable "connector_ymq_batch_size" {
  description = "Batch size for YMQ connector"
  type        = number
  default     = 1
}

variable "connector_yds_stream_name" {
  description = "YDS stream name for the connector"
  type        = string
  default     = "ydb-new"
}

variable "connector_yds_consumer" {
  description = "YDS consumer name for the connector"
  type        = string
  default     = "ydb-new"
}

variable "connector_yds_database" {
  description = "YDS database for the connector"
  type        = string
  default     = "/ru-central1/b1g3o4minpkuh10pd2rj/etn636at4r5dbg1vvh0u"
}

variable "connector_service_account_id" {
  description = "Service account which has read permission on the stream"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

variable "connector_timer_cron_expression" {
  description = "Cron expression for timer connector"
  type        = string
  default     = "0 45 16 ? * *"
}

variable "choosing_eventrouter_connector_type" {
  description = "Type of the Event Router Connector source (timer, ymq, yds)"
  type        = string
  default     = "ymq"

  validation {
    condition     = contains(["ymq", "yds", "timer"], var.choosing_eventrouter_connector_type)
    error_message = "The choosing_eventrouter_connector_type must be one of: ymq, yds, timer."
  }
}
