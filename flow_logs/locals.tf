locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  name   = "vpc-flow-logs"
  env_vars = {
    REGION          = var.region
    FLOW_LOGS_GROUP = aws_cloudwatch_log_group.main.name
    IAM_ROLE_ARN    = aws_iam_role.main.arn
  }

}
