locals {
  sns_topic_name = "${var.prefix}-inspector"
  prefix         = "${var.prefix}-${terraform.workspace}"

  lambda_name = "inspector-fixes"

  env_vars = {
    REGION       = "${var.region}"
    CW_LOG_GROUP = "${local.inspector_log_grp_name}"
  }
  inspector_log_grp_name = "${var.prefix}/inspector/mvdb-dev-ssh"
}
