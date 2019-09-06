# Create VPC Flow Logs

module "ssh_logins" {
  source = "../modules/lambda"

  name         = local.lambda_name
  prefix       = var.prefix
  default_tags = var.default_tags
  region       = var.region
  env_vars     = local.env_vars
}
