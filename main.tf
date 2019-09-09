module "prv_s3_objs" {
  source = "./prv_s3_objs"

  prefix       = "${var.prefix}"
  default_tags = "${var.default_tags}"
  region       = "${data.aws_region.current.name}"
  account_id   = "${data.aws_caller_identity.current.account_id}"
}

# module "flow_logs" {
#   source = "./flow_logs"

#   prefix       = var.prefix
#   default_tags = var.default_tags
#   region       = data.aws_region.current.name
# }

# module "ssh_logins" {
#   source = "./ssh_logins"

#   prefix       = var.prefix
#   default_tags = var.default_tags
#   region       = data.aws_region.current.name
# }


# module "inspector" {
#   source = "./inspector"

#   prefix       = "${var.prefix}"
#   default_tags = "${var.default_tags}"
#   region       = "${data.aws_region.current.name}"
# }


