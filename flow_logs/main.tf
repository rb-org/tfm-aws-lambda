# Create VPC Flow Logs

module "vpc_flow_logs" {
  source = "../modules/lambda"

  name         = local.name
  prefix       = var.prefix
  default_tags = var.default_tags
  region       = var.region
  env_vars     = local.env_vars
}
