resource "aws_cloudwatch_log_metric_filter" "main" {
  name           = "${local.metric_filter_name}"
  pattern        = "[Mon, day, timestamp, ip, id=sshd*, status = Invalid*]"
  log_group_name = "${local.log_group_name}"

  metric_transformation {
    name      = "${local.metric_filter_name}"
    namespace = "${local.metric_namespace}"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "main" {
  alarm_name                = "${local.alarm_name}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${local.metric_filter_name}"
  namespace                 = "${local.metric_namespace}"
  period                    = "120"
  datapoints_to_alarm       = "1"
  statistic                 = "Sum"
  threshold                 = "2"
  alarm_description         = "Enter Instance ID here"
  insufficient_data_actions = []

  alarm_actions   = ["${aws_sns_topic.main.arn}"]
  actions_enabled = true

}
