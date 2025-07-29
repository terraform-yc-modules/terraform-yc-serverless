module "eventrouter_multiple_rules" {
  source = "../../"

  bus_name        = "multiple-rules-event-bus"
  bus_description = "Event bus with multiple rules demonstration"

  depends_on = [
    time_sleep.wait_for_iam
  ]

  rules = [
    {
      name        = "rule-for-ymq"
      description = "Rule that routes events to YMQ"
      jq_filter   = ".source == \"application.orders\""

      targets = [
        {
          ymq = {
            queue_arn          = yandex_message_queue.orders_queue.arn
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        }
      ]
    },
    {
      name        = "rule-for-yds"
      description = "Rule that routes events to YDS stream"
      jq_filter   = ".source == \"application.analytics\""

      targets = [
        {
          yds = {
            stream_name        = "analytics-stream"
            database           = yandex_ydb_database_serverless.analytics_ydb.database_path
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        }
      ]
    },
    {
      name        = "rule-for-function"
      description = "Rule that routes events to Cloud Function"
      jq_filter   = ".type == \"user.action\""

      targets = [
        {
          function = {
            function_id        = yandex_function.user_action_function.id
            function_tag       = "$latest"
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        }
      ]
    },
    {
      name        = "rule-for-container"
      description = "Rule that routes events to Container"
      jq_filter   = ".severity == \"error\""

      targets = [
        {
          container = {
            container_id          = yandex_serverless_container.error_handler_container.id
            container_revision_id = yandex_serverless_container.error_handler_container.revision_id
            service_account_id    = yandex_iam_service_account.eventrouter_sa.id
            path                  = "/webhook"
          }
        }
      ]
    }
  ]

  connectors = [
    {
      name        = "timer-connector"
      description = "Timer-based connector for scheduled events"
      timer = {
        cron_expression = "0 0 */6 * * ?"
      }
    }
  ]
}
