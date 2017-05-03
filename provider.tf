# Specify the provider and access details
provider "aws" {
  region = "us-west-2"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile = "shehryar"
}

terraform {
  backend "s3" {
    bucket = "terraform-bucket-2016"
    key    = "kafka/terraform-dev.tfstate"
    region = "us-west-2"
  }
}
