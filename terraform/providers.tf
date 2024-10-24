provider "aws" {
  region = var.region
}

variable "region" {
  description = "tf-testing with love hehehe"
  default     = "us-east-1"
}