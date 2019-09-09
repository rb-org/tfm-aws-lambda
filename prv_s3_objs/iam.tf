# Lambda Execution Policy
data "aws_iam_policy_document" "lambda_exec_policy_doc" {
  statement {
    actions = [
      "s3:GetObjectAcl",
      "s3:PutObjectAcl"
    ]
    effect    = "Allow"
    resources = ["${aws_s3_bucket.private.arn}/*"]
  }
  statement {
    actions = [
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "lambda_exec_policy" {
  name   = "${local.lambda_name}-lambda-policy"
  policy = "${data.aws_iam_policy_document.lambda_exec_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = "${module.lambda.iam_role_name}"
  policy_arn = "${aws_iam_policy.lambda_exec_policy.arn}"
}




