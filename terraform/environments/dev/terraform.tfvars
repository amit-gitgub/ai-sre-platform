aws_region = "us-west-1"
vpc_cidr = "10.0.0.0/16"
# public_subnet_cidr = "10.0.1.0/24"
# private_subnet_cidr = "10.0.2.0/24"
environment = "dev"

public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
]

private_subnets = [
    "10.0.11.0/24",
    "10.0.12.0/24"
]

availibity_zones = [
    "us-west-1a",
    "us-west-1c"
]