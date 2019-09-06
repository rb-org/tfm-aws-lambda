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


module "inspect" {
  source = "./inspect"

  prefix       = var.prefix
  default_tags = var.default_tags
  region       = data.aws_region.current.name
}
