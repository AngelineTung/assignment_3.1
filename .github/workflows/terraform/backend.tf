terraform {
  backend "s3" {
    bucket         = "my-tfstate-bucket-prod"
    key            = "terraform/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "my-tf-locks-prod"
    encrypt        = true
  }
}
