output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnets" {
  description = "Public Subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnets" {
  description = "Private Subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.nat_gateway[*].id
}

output "public_security_group_id" {
  value = aws_security_group.public_sg.id
}

output "private_security_group_id" {
  value = aws_security_group.private_sg.id
}
