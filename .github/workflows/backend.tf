terraform {
  backend "s3" {
    bucket         = "my-tfstate-bucket-prod"   # existing bucket name
    key            = "infra/network/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "my-tf-locks-prod"         # for state locking
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
}