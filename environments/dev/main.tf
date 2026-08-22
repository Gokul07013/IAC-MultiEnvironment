module "vpc" {
  source = "../../modules/vpc"

  name = "mt"
  environment = "dev"
  cidr = "20.0.0.0/16"
  azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets = ["20.0.1.0/24", "20.0.2.0/24", "20.0.3.0/24"]
  private_subnets = ["20.0.101.0/24","20.0.102.0/24","20.0.103.0/24"]
  enable_nat_gateway = false
  tags = {
    Project = "Infra-Demo"
    Terraform = true
  }

}