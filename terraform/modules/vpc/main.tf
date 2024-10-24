#Create VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.proj_name}-${var.environment}-vpc"
  }
}

#Get all availability zones
data "aws_availability_zones" "available" {}

#Create public subnet and private subnet
resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.proj_name}-${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.private_subnet_cidr
  availability_zone       = data.aws_availability_zones.available.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.proj_name}-${var.environment}-private-subnet"
  }
}

#Create Internet Gateway for VPC
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.proj_name}-${var.environment}-igw"
  }
}

#Create NAT Gateway for VPC
resource "aws_eip" "nat-eip" {
  tags = {
    Name = "${var.proj_name}-${var.environment}-eip"
  }
}
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-subnet.id
  tags = {
    Name = "${var.proj_name}-${var.environment}-ngw"
  }
}

#Create public route table, routing rules and connect it to public subnet
resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.proj_name}-${var.environment}-public-rtb"
  }
}

resource "aws_route_table_association" "public-subnet-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

#Create private route table, routing rules and connect it to private subnet
resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }

  tags = {
    Name = "${var.proj_name}-${var.environment}-private-rtb"
  }
}

resource "aws_route_table_association" "private-subnet-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rtb.id
}