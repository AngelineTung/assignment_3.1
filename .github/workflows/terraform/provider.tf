terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  # optional but nice to assert:
  required_version = ">= 1.6.0"
}

provider "aws" {
  region = "ap-southeast-1"
}
