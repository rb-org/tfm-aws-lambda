resource "aws_sns_topic" "main" {
  name = "${local.sns_topic_name}"
}

resource "aws_sns_topic_subscription" "main" {
  topic_arn = "${aws_sns_topic.main.arn}"
  protocol  = "lambda"
  endpoint  = "${module.ssh_logins.arn}"
}
