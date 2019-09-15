locals {
  prefix      = "${var.prefix}-${terraform.workspace}"
  lambda_name = "access-keys"
  env_vars = {
    REGION = "${var.region}"
  }
}
