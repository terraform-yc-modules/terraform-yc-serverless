data "yandex_client_config" "client" {}

resource "yandex_iam_service_account" "eventrouter_sa" {
  name        = "eventrouter-multiple-rules-sa"
  description = "Service account for EventRouter multiple rules example operations"
  folder_id   = data.yandex_client_config.client.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_logging_writer" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "logging.writer"
  members = [
    "serviceAccount:${yandex_iam_service_account.eventrouter_sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_yds_viewer" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "yds.viewer"
  members = [
    "serviceAccount:${yandex_iam_service_account.eventrouter_sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_yds_writer" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "yds.writer"
  members = [
    "serviceAccount:${yandex_iam_service_account.eventrouter_sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_eventrouter_editor" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "serverless.eventrouter.editor"
  members = [
    "serviceAccount:${yandex_iam_service_account.eventrouter_sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_ymq_admin" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "ymq.admin"
  members = [
    "serviceAccount:${yandex_iam_service_account.eventrouter_sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_functions_invoker" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "serverless.functions.invoker"
  members = [
    "serviceAccount:${yandex_iam_service_account.eventrouter_sa.id}"
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_serverless_containers_invoker" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "serverless.containers.invoker"
  members = [
    "serviceAccount:${yandex_iam_service_account.eventrouter_sa.id}"
  ]
}

resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.eventrouter_sa.id
  description        = "Static access key for YMQ"
}

resource "yandex_message_queue" "orders_queue" {
  depends_on = [
    time_sleep.wait_for_iam
  ]
  name                       = "orders-queue"
  visibility_timeout_seconds = 600
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 1209600
  access_key                 = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key                 = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
}

resource "yandex_ydb_database_serverless" "analytics_ydb" {
  name        = "analytics-ydb"
  folder_id   = data.yandex_client_config.client.folder_id
  location_id = "ru-central1"

  serverless_database {
    enable_throttling_rcu_limit = false
    provisioned_rcu_limit       = 10
    storage_size_limit          = 50
    throttling_rcu_limit        = 0
  }
}

resource "yandex_function" "user_action_function" {
  name               = "user-action-function"
  description        = "Function for processing user actions"
  user_hash          = "user-action-hash"
  runtime            = "python39"
  entrypoint         = "index.handler"
  memory             = "128"
  execution_timeout  = "10"
  service_account_id = yandex_iam_service_account.eventrouter_sa.id

  content {
    zip_filename = data.archive_file.user_action_function_zip.output_path
  }
}

resource "local_file" "user_action_function_code" {
  content  = <<EOF
def handler(event, context):
    print(f"Processing user action event: {event}")
    return {
        'statusCode': 200,
        'body': 'User action processed successfully'
    }
EOF
  filename = "${path.module}/user-action-index.py"
}

data "archive_file" "user_action_function_zip" {
  type        = "zip"
  source_file = local_file.user_action_function_code.filename
  output_path = "${path.module}/user-action-function.zip"
  depends_on  = [local_file.user_action_function_code]
}

resource "yandex_logging_group" "example_log_group" {
  name             = "eventrouter-multiple-rules-log-group"
  folder_id        = data.yandex_client_config.client.folder_id
  retention_period = "72h"
}

resource "yandex_serverless_container" "error_handler_container" {
  name               = "error-handler-container"
  description        = "Container for handling error events"
  memory             = 128
  execution_timeout  = "10s"
  service_account_id = yandex_iam_service_account.eventrouter_sa.id

  image {
    url = "cr.yandex/yc/test-image:latest"
  }
}

resource "time_sleep" "wait_for_iam" {
  create_duration = "5s"
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_logging_writer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_yds_viewer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_yds_writer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_eventrouter_editor,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_ymq_admin,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_functions_invoker,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_serverless_containers_invoker
  ]
}
