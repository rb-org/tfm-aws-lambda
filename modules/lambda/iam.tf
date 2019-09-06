# Lambda Role
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.main.arn}"]
  }

  # statement {
  #   actions = [
  #     "*"
  #   ]
  #   effect    = "Allow"
  #   resources = ["*"]
  # }
}



resource "aws_iam_role" "lambda_role" {
  name               = "${local.lambda_name}-lambda-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.lambda_assume_role_policy.json}"
}

resource "aws_iam_policy" "lambda_policy" {
  name   = "${local.lambda_name}-lambda-policy"
  policy = "${data.aws_iam_policy_document.lambda_policy_doc.json}"
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}

