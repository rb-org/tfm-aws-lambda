resource "aws_cloudwatch_log_group" "ct_main" {
  name              = "${local.cw_ct_log_group}"
  retention_in_days = 3
  tags = "${merge(
    var.default_tags,
    map(
      "Environment", format("%s", terraform.workspace)
    )
  )}"
}

resource "aws_cloudwatch_event_rule" "main" {
  name        = "${local.lambda_name}-event-rule"
  description = "Catch public s3 events"

  event_pattern = <<PATTERN
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "PutObject",
      "PutObjectAcl"
    ],
    "requestParameters": {
      "bucketName": [
        "${aws_s3_bucket.private.id}"
      ]
    }
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
