data "aws_availability_zones" "available" {
  state = "available"
}

# Derive AZ list and matching /24 CIDR blocks for each AZ
locals {
  # Use up to 3 AZs, but don't exceed what's actually available
  n_azs = min(3, length(data.aws_availability_zones.available.names))
  azs   = slice(data.aws_availability_zones.available.names, 0, local.n_azs)

  # Carve public /24s from 10.0.0.0/16: 10.0.100.0/24, 10.0.101.0/24, ...
  public_subnets  = [for i in range(local.n_azs) : cidrsubnet("10.0.0.0/16", 8, 100 + i)]
  # Carve private /24s from 10.0.0.0/16: 10.0.1.0/24, 10.0.2.0/24, ...
  private_subnets = [for i in range(local.n_azs) : cidrsubnet("10.0.0.0/16", 8, 1 + i)]
# Carve database /24s from 10.0.0.0/16: 10.0.1.0/24, 10.0.2.0/24, ...
  database_subnets = [for i in range(3) : cidrsubnet("10.0.0.0/16", 8, 200 + i)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name = "angeline-vpc"
  cidr = "10.0.0.0/16"

  azs             = local.azs
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
 database_subnets = local.database_subnets

  # Networking features
  enable_nat_gateway   = true   # allow outbound internet from private subnets
  single_nat_gateway   = true   # single NAT shared across AZs (cheaper, less HA)
  enable_dns_hostnames = true   # EC2 hostnames + AmazonProvidedDNS
 #database features
 create_database_subnet_group = true
 database_subnet_group_name   = "angeline-db-subnet-group"

  tags = {
    Terraform  = "true"
    Environment = "dev"
  }
}
