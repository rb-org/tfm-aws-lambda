locals {
  prefix      = "${var.prefix}-${terraform.workspace}"
  lambda_name = "prv-s3-objects"
  env_vars = {
    REGION = "${var.region}"
  }
  ct_name         = "cloudtrail-test"
  ct_bucket       = "${local.ct_name}-${var.account_id}"
  prv_bucket_name = "${local.prefix}-private-${var.account_id}"
  cw_ct_log_group = "/aws/${local.ct_name}"
}
