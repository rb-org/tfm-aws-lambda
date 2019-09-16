resource "aws_config_delivery_channel" "main" {
  name           = "${local.config_name}"
  s3_bucket_name = "${aws_s3_bucket.main.bucket}"
  depends_on     = ["aws_config_configuration_recorder.main"]
}

resource "aws_config_configuration_recorder" "main" {
  name     = "${local.config_name}"
  role_arn = "${aws_iam_role.config.arn}"
  recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types = [
      "AWS::EC2::Instance",
    ]
  }
}

resource "aws_config_configuration_recorder_status" "main" {
  name       = "${aws_config_configuration_recorder.main.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.main"]
}

# Rules

resource "aws_config_config_rule" "main" {
  name        = "${local.prefix}-check-ec2-type"
  description = "Checks that all EC2 instances are of the type specified."
  source {
    owner             = "CUSTOM_LAMBDA"
    source_identifier = "${module.lambda.arn}"
    source_detail {
      event_source = "aws.config"
      message_type = "ConfigurationItemChangeNotification"
    }
  }

  depends_on = ["aws_config_configuration_recorder.main", "aws_lambda_permission.config"]
}
