# Policy to allow Lambda to stop ec2 instances
data "aws_iam_policy_document" "lambda_exec_policy_doc" {
  statement {
    actions = [
      "inspector:DescribeFindings"
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
  role       = "${module.inspector.iam_role_name}"
  policy_arn = "${aws_iam_policy.lambda_exec_policy.arn}"
}

# Allow Lambda to run SSM jobs
resource "aws_iam_role_policy_attachment" "lambda_ssm_policy" {
  role       = "${module.inspector.iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMFullAccess"
}

# Allow SNS to trigger Lambda
resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${module.inspector.function_name}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.main.arn}"
}
