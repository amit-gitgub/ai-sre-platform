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
  count = length(var.public_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnets[count.index]
  map_public_ip_on_launch = true
  availability_zone = var.availabilty_zones[count.index]
  
  tags = {
    Name = "${var.environment}-public-${count.index}"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                    = "1"
  }
  
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnets[count.index]
  availability_zone = var.availabilty_zones[count.index]

  tags = {
    Name = "${var.environment}-private-${count.index}"
  }
  
}

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "${var.environment}-public-rt"
  }
}

resource "aws_route_table_association" "public" {

  count = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# resource "aws_subnet" "public" {
#   vpc_id = aws_vpc.this.id
#   cidr_block = var.public_subnet_cidr
#   map_public_ip_on_launch = true
#   availability_zone = "us-west-1a"

#   tags = {
#     Name = "${var.environment}-public"
#   }
# }

# resource "aws_subnet" "private" {
#   vpc_id = aws_vpc.this.id
#   cidr_block = var.private_subnet_cidr
#   availability_zone = "us-west-1c"

#   tags = {
#     Name = "${var.environment}-private"
#   }
# }


