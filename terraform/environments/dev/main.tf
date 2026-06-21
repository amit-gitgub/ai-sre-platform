provider "aws" {
    region = var.aws_region
  
}

module "vpc" {
    source = "../../modules/vpc"
    vpc_cidr = var.vpc_cidr
    public_subnet_cidr = var.public_subnet_cidr
    private_subnet_cidr = var.private_subnet_cidr
    environment = var.environment
  
}

module "security_group" {
    source = "../../modules/security-group"
    environment = var.environment
    vpc_id = module.vpc.vpc_id
}

resource "aws_s3_bucket" "tf_state" {
    bucket = "amit-ai-sre-tfstate"
  
}

# Currently we are going ahead only with the local state only.. Once we 
# will go for remote state then we will enable this dynamo DB locking block

# resource "aws_dynamodb_table" "lock" {
#     name = "terraform-lock"
#     billing_mode = "PAY_PER_REQUEST"
#     hash_key = "LockID"
#     attribute {
#       name = "LockID"
#       type = "S"
#     }
  
# }