module "vpc" {
  source = "./modules/vpc"
  
  region = "us-east-1"
  proj_name = "testing"
  environment = "terraform"

  vpc_cidr = "10.10.0.0/16"
  public_subnet_cidr = "10.10.10.0/24"
  private_subnet_cidr = "10.10.20.0/24"
}