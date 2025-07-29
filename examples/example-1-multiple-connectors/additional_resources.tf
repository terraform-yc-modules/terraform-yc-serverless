data "yandex_client_config" "client" {}

resource "yandex_iam_service_account" "eventrouter_sa" {
  name        = "eventrouter-example-sa"
  description = "Service account for EventRouter example operations"
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

resource "yandex_logging_group" "example_log_group" {
  name             = "eventrouter-example-log-group"
  folder_id        = data.yandex_client_config.client.folder_id
  retention_period = "72h"
}

resource "yandex_ydb_database_serverless" "example_ydb" {
  name        = "eventrouter-example-ydb"
  folder_id   = data.yandex_client_config.client.folder_id
  location_id = "ru-central1"

  serverless_database {
    enable_throttling_rcu_limit = false
    provisioned_rcu_limit       = 10
    storage_size_limit          = 50
    throttling_rcu_limit        = 0
  }
}

resource "yandex_ydb_database_serverless" "consumer_ydb" {
  name        = "eventrouter-consumer-ydb"
  folder_id   = data.yandex_client_config.client.folder_id
  location_id = "ru-central1"

  serverless_database {
    enable_throttling_rcu_limit = false
    provisioned_rcu_limit       = 10
    storage_size_limit          = 50
    throttling_rcu_limit        = 0
  }
}

resource "time_sleep" "wait_for_iam" {
  create_duration = "5s"
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_logging_writer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_yds_viewer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_yds_writer,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_eventrouter_editor
  ]
}
