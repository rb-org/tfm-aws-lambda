resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/inspector"
  retention_in_days = 3
}
