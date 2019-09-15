locals {
  prefix      = "${var.prefix}-${terraform.workspace}"
  lambda_name = "tag-ec2"
  env_vars = {
    REGION = "${var.region}"
  }
}
