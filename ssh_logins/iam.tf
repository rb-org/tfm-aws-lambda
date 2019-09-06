# Policy to allow Lambda to stop ec2 instances
data "aws_iam_policy_document" "lambda_exec_policy_doc" {
  statement {
    actions = [
      "ec2:StopInstances"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

}

resource "aws_iam_policy" "lambda_exec_policy" {
  name   = "${local.lambda_name}-lambda-exec-policy"
  policy = "${data.aws_iam_policy_document.lambda_exec_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = "${module.ssh_logins.iam_role_name}"
  policy_arn = "${aws_iam_policy.lambda_exec_policy.arn}"
}

# Policy to allow SNS to invoke Lambda

# resource "aws_sns_topic_policy" "sns_topic_policy" {
#   arn    = "${aws_sns_topic.main.arn}"
#   policy = "${data.aws_iam_policy_document.sns_topic_policy_doc.json}"
# }

# data "aws_iam_policy_document" "sns_topic_policy_doc" {
#   statement {
#     actions = [
#       "lambda:invokeFunction"
#     ]
#     effect    = "Allow"
#     resources = ["${module.ssh_logins.arn}"]
#     # principals {
#     #   type        = "Service"
#     #   identifiers = ["sns.amazonaws.com"]
#     # }
#   }
# }

resource "aws_lambda_permission" "sns" {
  statement_id = "AllowExecutionFromSNS"
  action       = "lambda:InvokeFunction"
  # function_name = "${local.lambda_name}"
  function_name = "${module.ssh_logins.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.main.arn}"
}
