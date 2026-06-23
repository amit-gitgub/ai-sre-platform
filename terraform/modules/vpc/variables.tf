variable "vpc_cidr" {
  
}




# Updating the vpc module to create and handle multiple public and private subnets

# Public Subnet A
# Public Subnet C

# Private Subnet A
# Private Subnet C

# Example

# 10.0.1.0/24   us-west-1a   public
# 10.0.2.0/24   us-west-1c   public

# 10.0.11.0/24  us-west-1a   private
# 10.0.12.0/24  us-west-1c   private

variable "public_subnets" {
    type = list(string)
  
}

variable "private_subnets" {
    type = list(string)
  
}

variable "availabilty_zones" {
    type = list(string)
  
}

variable "environment" {
  
}

variable "cluster_name" {
  
}

