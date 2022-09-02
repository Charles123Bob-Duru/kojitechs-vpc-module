# root module

terraform {
  required_version = "~> 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

locals {
  vpc_id = aws_vpc.kojitech_vpc.id
  azs    = data.aws_availability_zones.available.names
}

# Declare the data source
data "aws_availability_zones" "available" {
  state = "available"
}

# creating VPC

resource "aws_vpc" "kojitech_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.vpc_tags
}


#creating internet gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.kojitech_vpc.id

  tags = {
    Name = "gw"
  }
}

# creating subnet
resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_cidr) # tell terraform to calculate the size of the cider avaliable 
  vpc_id                  = local.vpc_id
  cidr_block              = var.public_cidr[count.index]
  availability_zone       = element(slice(local.azs, 0, 2), count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

#private subnet 
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_cidr) # tell terraform to calculate the size of the cider avaliable 
  vpc_id                  = local.vpc_id
  cidr_block              = var.private_cidr[count.index]
  availability_zone       = element(slice(local.azs, 0, 2), count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

#database subnet
resource "aws_subnet" "database_subnet" {
  count                   = length(var.database_cidr) # tell terraform to calculate the size of the cider avaliable 
  vpc_id                  = local.vpc_id
  cidr_block              = var.database_cidr[count.index]
  availability_zone       = element(slice(local.azs, 0, 2), count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = "database_subnet_${count.index + 1}"
  }
}

#  public Route table 

resource "aws_route_table" "public_route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public_route_table"
  }
}


#creating a route table for public subnet association
resource "aws_route_table_association" "public_association" {
  count          = length(var.public_cidr)
  subnet_id      = aws_subnet.public_subnet[0].id
  route_table_id = aws_route_table.public_route_table.id
}

#default route table
resource "aws_default_route_table" "default_route_table" {
  default_route_table_id = aws_vpc.kojitech_vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

}

#creating a nat gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id # will not be good to have a dynamic address on a nat device 
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.gw]
}

#creating EIP ELASTIC IP 
resource "aws_eip" "eip" {
  #instance = aws_instance.web.id
  vpc        = true
  depends_on = [aws_internet_gateway.gw]
} 
