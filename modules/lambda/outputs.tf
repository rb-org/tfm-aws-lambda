output "arn" {
  value = "${aws_lambda_function.main.arn}"
}
output "function_name" {
  value = "${aws_lambda_function.main.function_name}"
}
output "iam_role_arn" {
  value = "${aws_iam_role.lambda_role.arn}"
}

output "iam_role_name" {
  value = "${aws_iam_role.lambda_role.name}"
}
