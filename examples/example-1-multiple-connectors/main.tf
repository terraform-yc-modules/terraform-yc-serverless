module "eventrouter_mixed_connectors" {
  source = "../../"

  bus_name        = "mixed-event-bus"
  bus_description = "Event bus with mixed connector types"

  depends_on = [
    time_sleep.wait_for_iam
  ]

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

  connectors = [
    {
      name        = "timer-connector-1"
      description = "Timer-based connector"
      timer = {
        cron_expression = "0 0 12 * * ?"
      }
    },
    {
      name        = "timer-connector-2"
      description = "New timer-based connector"
      timer = {
        cron_expression = "0 45 16 ? * *"
      }
    },
    {
      name        = "yds-connector-1"
      description = "YDS stream connector"
      yds = {
        stream_name        = "events-stream"
        consumer           = "events-consumer"
        database           = yandex_ydb_database_serverless.example_ydb.database_path
        service_account_id = yandex_iam_service_account.eventrouter_sa.id
      }
    }
  ]
}
