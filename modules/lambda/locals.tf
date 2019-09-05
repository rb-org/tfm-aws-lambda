locals {
  prefix      = "${var.prefix}-${terraform.workspace}"
  lambda_name = "${local.prefix}-${var.name}"
  # env_vars = {
  #   REGION = var.region
  # }
  lambda_filename = "${var.name}"
}
