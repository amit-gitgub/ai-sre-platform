resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      Name = "${var.environment}-vpc"
    }
  
}

resource "aws_internet_gateway" "this" {
    vpc_id = aws_vpc.this.id

    tags = {
      Name = "${var.environment}-igw"
    }
  
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = "us-west-1a"

  tags = {
    Name = "${var.environment}-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "us-west-1c"

  tags = {
    Name = "${var.environment}-private"
  }
}


