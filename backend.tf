terraform {
  required_version = "~>0.12"

  backend "s3" {
    bucket                  = "tfm-remote-state-240442524813"
    region                  = "eu-west-1"
    key                     = "la-lambda.tfstate"
    encrypt                 = "true"
    shared_credentials_file = "~/.aws/credentials"
    profile                 = "ofs-sandbox"
  }
}


