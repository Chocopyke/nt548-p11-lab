provider "aws" {
  region = var.region
  profile = "terraform-user"

  default_tags {
  tags = {
    "Automation" = "terraform"
    "Project" = var.proj_name
    "Environment" = var.environment
    }
}
}