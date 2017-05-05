# Specify the provider and access details
provider "aws" {
  region = "us-west-2"
  shared_credentials_file = "/home/ubuntu/.aws/credentials"
  profile = "shehryar"
}

terraform {
  backend "s3" {
    bucket = "terraform-kafka-bucket"
    key    = "/dev/terraform-dev.tfstate"
    region = "us-west-2"
  }
}
