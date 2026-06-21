output "vpc_id" {
  value = aws_vpc.sre_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet
}