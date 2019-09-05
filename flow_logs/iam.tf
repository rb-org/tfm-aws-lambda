

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "main" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    effect    = "Allow"
    resources = ["*"]
  }

}



resource "aws_iam_role" "main" {
  name               = "${local.name}-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
}

resource "aws_iam_policy" "main" {
  name   = "${local.name}-policy"
  policy = "${data.aws_iam_policy_document.main.json}"
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = "${aws_iam_role.main.name}"
  policy_arn = "${aws_iam_policy.main.arn}"
}
