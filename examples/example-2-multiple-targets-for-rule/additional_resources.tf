data "yandex_client_config" "client" {}

resource "yandex_iam_service_account" "eventrouter_sa" {
  name        = "eventrouter-multi-target-sa"
  description = "Service account for EventRouter multi-target example operations"
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

resource "yandex_logging_group" "example_log_group" {
  name             = "eventrouter-multi-target-log-group"
  folder_id        = data.yandex_client_config.client.folder_id
  retention_period = "72h"
}

resource "yandex_ydb_database_serverless" "example_ydb" {
  name        = "eventrouter-multi-target-ydb"
  folder_id   = data.yandex_client_config.client.folder_id
  location_id = "ru-central1"

  serverless_database {
    enable_throttling_rcu_limit = false
    provisioned_rcu_limit       = 10
    storage_size_limit          = 50
    throttling_rcu_limit        = 0
  }
}

resource "yandex_message_queue" "example_queue_1" {
  depends_on = [
    time_sleep.wait_for_iam
  ]
  name                       = "multi-target-queue-1"
  visibility_timeout_seconds = 600
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 1209600
  access_key                 = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key                 = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
}

resource "yandex_message_queue" "example_queue_2" {
  depends_on = [
    time_sleep.wait_for_iam
  ]
  name                       = "multi-target-queue-2"
  visibility_timeout_seconds = 600
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 1209600
  access_key                 = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key                 = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
}

resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.eventrouter_sa.id
  description        = "Static access key for YMQ"
}

resource "yandex_function" "example_function" {
  name               = "multi-target-function"
  description        = "Example function for multi-target EventRouter"
  user_hash          = "example-hash"
  runtime            = "python39"
  entrypoint         = "index.handler"
  memory             = "128"
  execution_timeout  = "10"
  service_account_id = yandex_iam_service_account.eventrouter_sa.id

  content {
    zip_filename = data.archive_file.function_zip.output_path
  }
}

resource "local_file" "function_code" {
  content  = <<EOF
def handler(event, context):
    print(f"Received event: {event}")
    return {
        'statusCode': 200,
        'body': 'Event processed successfully'
    }
EOF
  filename = "${path.module}/index.py"
}

data "archive_file" "function_zip" {
  type        = "zip"
  source_file = local_file.function_code.filename
  output_path = "${path.module}/function.zip"
  depends_on  = [local_file.function_code]
}

resource "time_sleep" "wait_for_iam" {
  create_duration = "5s"
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_logging_writer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_yds_viewer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_yds_writer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_eventrouter_editor,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_ymq_admin,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_functions_invoker
  ]
}
