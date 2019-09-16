locals {
  prefix      = "${var.prefix}-${terraform.workspace}"
  lambda_name = "config-ec2"
  env_vars = {
    REGION = "${var.region}"
  }
  config_name = "${local.prefix}"
  bucket_name = "${local.prefix}-config-${var.account_id}"
}
