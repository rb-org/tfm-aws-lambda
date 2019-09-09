resource "aws_sns_topic" "main" {
  name = "${local.sns_topic_name}"
}

resource "aws_sns_topic_subscription" "main" {
  topic_arn = "${aws_sns_topic.main.arn}"
  protocol  = "lambda"
  endpoint  = "${module.inspector.arn}"
}

# Allow Inspector to subscribe and publish to SNS topic
resource "aws_sns_topic_policy" "main" {
  arn = "${aws_sns_topic.main.arn}"

  policy = "${data.aws_iam_policy_document.sns-topic-policy.json}"
}

data "aws_iam_policy_document" "sns-topic-policy" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::357557129151:root"]
    }

    resources = [
      "${aws_sns_topic.main.arn}",
    ]

    sid = "__default_statement_ID"
  }
}
