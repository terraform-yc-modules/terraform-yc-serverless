module "eventrouter_single_connector" {
  source = "../../"

  bus_name        = "single-event-bus"
  bus_description = "Event bus with single connector"

  depends_on = [
    time_sleep.wait_for_iam
  ]

  rules = [
    {
      name        = "single-rule"
      description = "Rule for single connector"
      jq_filter   = ""

      targets = [
        {
          ymq = {
            queue_arn          = yandex_message_queue.example_queue.arn
            service_account_id = yandex_iam_service_account.eventrouter_sa.id
          }
        }
      ]
    }
  ]

  connectors = [
    {
      name        = "timer-connector"
      description = "Single timer-based connector"
      timer = {
        cron_expression = "0 0 12 * * ?"
      }
    }
  ]
}
