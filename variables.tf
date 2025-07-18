# Serverless parameters
variable "folder_id" {
  description = "The ID of the folder that the resources belong to."
  type        = string
  default     = null
}

# Event Router Bus variables
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

# Event Router Rule variables
variable "rule_name" {
  description = "Name of the Event Router Rule"
  type        = string
  default     = "event-rule"
}

variable "rule_description" {
  description = "Description of the Event Router Rule"
  type        = string
  default     = "Yandex Cloud EventRouter Rule"
}

variable "rule_jq_filter" {
  description = "JQ filter for the Event Router Rule"
  type        = string
  default     = ""
}

variable "rule_labels" {
  description = "Labels for the Event Router Rule"
  type        = map(string)
  default     = {}
}

# Event Router Rule Target Selection
variable "choosing_eventrouter_rule_target_type" {
  description = "Type of the Event Router Rule target (container, function, gateway_websocket_broadcast, workflow, logging, yds, ymq)"
  type        = string
  default     = "ymq"
  validation {
    condition     = contains(["container", "function", "gateway_websocket_broadcast", "workflow", "logging", "yds", "ymq"], var.choosing_eventrouter_rule_target_type)
    error_message = "The choosing_rule_target_type must be one of: container, function, gateway_websocket_broadcast, workflow, logging, yds, ymq."
  }
}

# Container target variables
variable "rule_container_id" {
  description = "Container ID for the Event Router Rule container target"
  type        = string
  default     = "bbaq1kcpp2r0uqfgut5j"
}

variable "rule_container_revision_id" {
  description = "Container Revision ID for the Event Router Rule container target"
  type        = string
  default     = "bbabllu6ck26rehi97ie"
}

variable "rule_container_path" {
  description = "Container path for the Event Router Rule container target"
  type        = string
  default     = "https://bbaq1kcpp2r0uqfgut5j.containers.yandexcloud.net/"
}

variable "rule_container_service_account_id" {
  description = "Service account which should be used to call a container"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

# Function target variables
variable "rule_function_id" {
  description = "Function ID for the Event Router Rule function target"
  type        = string
  default     = "d4es4g1ptv913vpu5u28"
}

variable "rule_function_tag" {
  description = "Function tag for the Event Router Rule function target"
  type        = string
  default     = "$latest"
}

variable "rule_function_service_account_id" {
  description = "Service account which has call permission on the function"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

# Gateway WebSocket Broadcast target variables
variable "rule_gateway_websocket_broadcast_gateway_id" {
  description = "Gateway ID for the Event Router Rule gateway websocket broadcast target"
  type        = string
  default     = "d5dl4tujg041khot5h6c"
}

variable "rule_gateway_websocket_broadcast_path" {
  description = "Path for the Event Router Rule gateway websocket broadcast target"
  type        = string
  default     = "https://d5dl4tujg041khot5h6c.i99u1wfk.apigw.yandexcloud.net"
}

variable "rule_gateway_websocket_broadcast_service_account_id" {
  description = "Service account which has permission for writing to websockets"
  type        = string
  default     = "aje34qflj6lfp44cmbsq" # api-gateway.websocketBroadcaster role should be added to service account
}

# Workflow target variables
variable "rule_workflow_id" {
  description = "Workflow ID for the Event Router Rule workflow target"
  type        = string
  default     = "dfqh2gr30gf3ah127fhp"
}

variable "rule_workflow_service_account_id" {
  description = "Service account which should be used to start workflow"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

# Logging target variables
variable "rule_logging_log_group_id" {
  description = "Log group ID for the Event Router Rule logging target"
  type        = string
  default     = "e23moaejmq8m74tssfu9"
}

variable "rule_logging_service_account_id" {
  description = "Service account which has permission for writing logs"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

# YDS target variables
variable "rule_yds_stream_name" {
  description = "YDS stream name for the Event Router Rule YDS target"
  type        = string
  default     = "ydb-new"
}

variable "rule_yds_database" {
  description = "YDS database for the Event Router Rule YDS target"
  type        = string
  default     = "/ru-central1/b1g3o4minpkuh10pd2rj/etn636at4r5dbg1vvh0u"
}

variable "rule_yds_service_account_id" {
  description = "Service account, which has write permission on the stream"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

# YMQ target variables
variable "rule_ymq_queue_arn" {
  description = "YMQ queue ARN for the Event Router Rule YMQ target"
  type        = string
  default     = "yrn:yc:ymq:ru-central1:b1gfl7u3a9ahaamt3ore:mq"
}

variable "rule_ymq_service_account_id" {
  description = "Service account which has write access to the queue"
  type        = string
  default     = "aje34qflj6lfp44cmbsq"
}

# Event Router Connector variables
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

# YMQ Connector variables
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

# YDS Connector variables
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
    error_message = "The choosing_connector_type must be one of: ymq, yds, timer."
  }
}
