

resource "aws_cloudwatch_event_rule" "main" {
  name        = "${local.prefix}-${local.name}-event-rule"
  description = "Catch VPC creation events"

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
             "CreateVpc"
         ]
     }
 }
PATTERN
}

resource "aws_cloudwatch_event_target" "main" {
  target_id  = "${local.prefix}-${local.name}"
  rule       = "${aws_cloudwatch_event_rule.main.name}"
  arn        = "${module.vpc_flow_logs.arn}"
  input_path = "$.detail.responseElements.vpc.vpcId"

}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 1
}

