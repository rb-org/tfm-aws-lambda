
resource "aws_cloudwatch_event_rule" "main" {
  name        = "${local.lambda_name}-event-rule"
  description = "Schedule to start lambda at 20:00 daily"

  schedule_expression = "cron(0 20 * * ? *)"
}


resource "aws_cloudwatch_event_target" "main" {
  target_id = "${local.lambda_name}"
  rule      = "${aws_cloudwatch_event_rule.main.name}"
  arn       = "${module.lambda.arn}"
  # input_path = "$.detail.responseElements.vpc.vpcId"

}
# Allow CW to trigger Lambda
resource "aws_lambda_permission" "cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.main.arn}"
}
