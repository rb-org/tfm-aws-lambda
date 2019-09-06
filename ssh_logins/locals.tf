locals {
  sns_topic_name     = "${var.prefix}-cw-alarms"
  metric_filter_name = "invalid-ssh-login"
  metric_namespace   = "SSH"
  alarm_name         = "InvalidSSHLoginAlarm"
  log_group_name     = "/mvdb/mvdb-dev-ssh-log-group"
  prefix             = "${var.prefix}-${terraform.workspace}"

  lambda_name = "ssh-invalid-login"

  env_vars = {
    REGION = var.region
  }
}
