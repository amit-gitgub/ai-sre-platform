provider "aws" {
    region = var.aws_region
}

resource "aws_vpc" "sre_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true

    tags = {
        Name = "ai-sre-vpc"
    }
  
}

resource "aws_internet_gateway" "iwg" {
    vpc_id = aws_vpc.sre_vpc.id

    tags = {
      Name = "ai-sri-igw"
    }
  
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.sre_vpc.id
    cidr_block = var.public_subnet_cidr
    map_public_ip_on_launch = true
    availability_zone = "us-west-1a"

    tags = {
      Name = "public-subnet"
    }
  
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.sre_vpc.id
    cidr_block = var.private_subnet_cidr
    availability_zone = "us-west-1c"

    tags = {
        Name = "private-subnet"
    }
  
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.sre_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.iwg.id
    }
    tags = {
      Name = "public-rt"
    }
    }
  
resource "aws_route_table_association" "public_assoc" {

  subnet_id = aws_subnet.public_subnet.id

  route_table_id = aws_route_table.public_rt.id
}

resource "aws_security_group" "sre_sg" {
    name = "ai-sre-sg"
    vpc_id = aws_vpc.sre_vpc.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]

    }
    tags = {
        Name = "ai-sre-sg"
    }
        
    }
  
