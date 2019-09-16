# Lambda Execution Policy
data "aws_iam_policy_document" "lambda_exec_policy_doc" {

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

resource "aws_iam_role_policy_attachment" "lambda_config_policy" {
  role       = "${module.lambda.iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRulesExecutionRole"
}


# AWS Config Role

resource "aws_iam_role" "config" {
  name = "${local.prefix}-config-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

# resource "aws_iam_role_policy" "config" {
#   name = "${local.prefix}-config-policy"
#   role = "${aws_iam_role.config.id}"

#   policy = <<POLICY
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "s3:*"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "${aws_s3_bucket.main.arn}",
#         "${aws_s3_bucket.main.arn}/*"
#       ]
#     }
#   ]
# }
# POLICY
# }

resource "aws_iam_role_policy_attachment" "config" {
  role       = "${aws_iam_role.config.name}"
  policy_arn = "arn:aws:iam::240442524813:role/aws-service-role/config.amazonaws.com/AWSServiceRoleForConfig"
}
# resource "aws_iam_policy" "config" {
#   name   = "${local.prefix}-config-policy"
#   policy = "${data.aws_iam_policy_document.config_policy_doc.json}"
# }
# data "aws_iam_policy_document" "config_policy_doc" {

#   statement {
#     actions = [
#       "s3:*"
#     ]
#     effect = "Allow"
#     resources = [
#       "${aws_s3_bucket.main.arn}",
#       "${aws_s3_bucket.main.arn}/*"
#     ]
#   }
#   statement {
#     actions = [
#       "config:Put*"
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
#   statement {
#     actions = [
#       "*"
#     ]
#     effect    = "Allow"
#     resources = ["*"]
#   }
# }

resource "aws_iam_role_policy_attachment" "config_policy" {
  role       = "${module.lambda.iam_role_name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}
