# terraform {
#   backend "s3" {
#     bucket = "amit-ai-sre-tfstate"
#     key = "dev/terraform.tfstate"
#     region = "us-west-1"
#     dynamodb_table = "terraform-lock"
#     encrypt = true
    
#   }
# }