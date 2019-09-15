

resource "aws_cloudwatch_event_rule" "main" {
  name        = "${local.lambda_name}-event-rule"
  description = "Tag new EC2 resources"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.ec2"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "ec2.amazonaws.com"
    ],
    "eventName": [
      "CreateImage",
      "CreateSnapshot",
      "CreateVolume",
      "RunInstances"
    ]
  }
}
PATTERN
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
