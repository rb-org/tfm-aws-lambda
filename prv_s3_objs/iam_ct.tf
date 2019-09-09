data "aws_iam_policy_document" "ct_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ct_main" {
  name               = "${local.ct_name}-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.ct_assume_role_policy.json}"
}

data "aws_iam_policy_document" "ct_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.ct_main.arn}"]
  }
}

resource "aws_iam_policy" "ct_main" {
  name   = "${local.ct_name}-policy"
  policy = "${data.aws_iam_policy_document.ct_policy_doc.json}"
}


resource "aws_iam_role_policy_attachment" "attach" {
  role       = "${aws_iam_role.ct_main.name}"
  policy_arn = "${aws_iam_policy.ct_main.arn}"
}

