#Create Security Group for public instance
resource "aws_security_group" "public-ec2-sg" {
  vpc_id = aws_vpc.vpc.id
  description = "Public security group for VPC"
  ingress = [
    {
      description = "Ingress rules for public instance"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = [var.default_cidr]
      self = false
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
    },
    {
      description = "Ingress rules for public instance"
      from_port   = 80
      to_port     = 80
      protocol    = "http"
      cidr_blocks = [var.default_cidr]
      self = false
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
    }
  ]
  egress = [
    {
      description = "Egress rules for public instance"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.default_cidr]
      self = false
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
    } 
  ]
  tags = {
    Name = var.proj-name
  }
}
#Create Security Group for private instance
resource "aws_security_group" "private-ec2-sg" {
  vpc_id = aws_vpc.vpc.id
  description = "Public security group for VPC"
  ingress = [
    {
      description = "Ingress rules for public instance"
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = []
      self = false
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = [aws_security_group.public-ec2-sg.id]
    }
  ]
  egress = [
    {
      description = "Egress rules for public instance"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = [var.default_cidr]
      self = false
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
    } 
  ]
  tags = {
    Name = var.proj-name
  }
}

#Create public EC2 instance
resource "aws_instance" "fe-instance" {
  ami = var.ami-id
  instance_type = var.instace-type
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = aws_security_group.public-ec2-sg.id
  associate_public_ip_address = true
  key_name = var.key
  tags = {
    Name = "public-instance"
  }
}
#Create private EC2 instance 1

#Create private EC2 instance 2

#Create private EC2 instance 3