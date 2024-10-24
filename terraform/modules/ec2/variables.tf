variable "vpc_id" {}

variable "public_subnet_id" {}

variable "private_subnet_id" {}

variable "ami-id" {
  default = "ami-0866a3c8686eaeeba"
}

variable "instace-type" {
  default = "t2.micro"
}

variable "key" {
  default = "TerraformTestKey"
}

variable "proj-name" {
  default = "tf-tesing"
}

variable "default_cidr" {
  default = "0.0.0.0/0"
}