data "yandex_client_config" "client" {}

resource "yandex_iam_service_account" "eventrouter_sa" {
  name        = "eventrouter-single-connector-sa"
  description = "Service account for EventRouter single connector example operations"
  folder_id   = data.yandex_client_config.client.folder_id
}

resource "yandex_resourcemanager_folder_iam_binding" "eventrouter_sa_ymq_admin" {
  folder_id = data.yandex_client_config.client.folder_id
  role      = "ymq.admin"
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

resource "yandex_iam_service_account_static_access_key" "sa_static_key" {
  service_account_id = yandex_iam_service_account.eventrouter_sa.id
  description        = "Static access key for YMQ"
}

resource "yandex_message_queue" "example_queue" {
  depends_on = [
    time_sleep.wait_for_iam
  ]
  name                       = "single-connector-queue"
  visibility_timeout_seconds = 600
  receive_wait_time_seconds  = 20
  message_retention_seconds  = 1209600
  access_key                 = yandex_iam_service_account_static_access_key.sa_static_key.access_key
  secret_key                 = yandex_iam_service_account_static_access_key.sa_static_key.secret_key
}

resource "time_sleep" "wait_for_iam" {
  create_duration = "5s"
  depends_on = [
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_ymq_admin,
    yandex_resourcemanager_folder_iam_binding.eventrouter_sa_eventrouter_editor
  ]
}
