module "eventrouter_multiple_targets" {
  source = "../../"

  bus_name        = "multi-target-event-bus"
  bus_description = "Event bus with multiple targets for a single rule"

  depends_on = [
    time_sleep.wait_for_iam
  ]

  rules = [
    {
      name        = "multi-target-rule"
      description = "Rule with multiple targets"
      jq_filter   = ".source == \"my-app\""

      targets = [
        {
          ymq = {
            queue_arn          = yandex_message_queue.example_queue_1.arn
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        },
        {
          ymq = {
            queue_arn          = yandex_message_queue.example_queue_2.arn
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        },
        {
          function = {
            function_id        = yandex_function.example_function.id
            function_tag       = "$latest"
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        },
        {
          yds = {
            stream_name        = "processed-events-stream"
            database           = yandex_ydb_database_serverless.example_ydb.database_path
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        },
        {
          logging = {
            log_group_id       = yandex_logging_group.example_log_group.id
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        }
      ]
    }
  ]

  connectors = [
    {
      name        = "timer-connector"
      description = "Timer-based connector for multi-target example"
      timer = {
        cron_expression = "0 0 */6 * * ?"
      }
    },
    {
      name        = "ymq-connector"
      description = "YMQ connector for multi-target example"
      ymq = {
        queue_arn          = yandex_message_queue.example_queue_2.arn
        service_account_id = yandex_iam_service_account.eventrouter_sa.id
        batch_size         = 5
      }
    }
  ]
}
