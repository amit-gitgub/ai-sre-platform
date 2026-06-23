provider "aws" {
    region = var.aws_region
  
}

module "vpc" {
    source = "../../modules/vpc"
    vpc_cidr = var.vpc_cidr
    public_subnets = var.public_subnets
    private_subnets = var.private_subnets
    environment = var.environment
    availabilty_zones = var.availibity_zones
    cluster_name = "ai-sre-dev-eks"
  
}

module "security_group" {
    source = "../../modules/security-group"
    environment = var.environment
    vpc_id = module.vpc.vpc_id
}

# resource "aws_s3_bucket" "tf_state" {
#     bucket = "amit-ai-sre-tfstate"
  
# }

module "eks" {
    source = "../../modules/eks"
    cluster_name = "ai-sre-dev-eks"
    private_subnet_ids = module.vpc.private_subnet_ids
    public_subnet_ids = module.vpc.public_subnet_ids
    environment = var.environment
    
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