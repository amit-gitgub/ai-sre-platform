output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_id" {
  value = module.vpc.private_subnet_ids
}

output "security_group_id" {
  value = module.security_group.sg_id
}