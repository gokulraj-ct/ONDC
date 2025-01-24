output "vpc_id" {
  value       = aws_vpc.test.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = length(var.cidr_public_subnet_block) > 0 ? aws_subnet.public_subnet[*].id : []
  description = "IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = length(var.cidr_private_subnet_block) > 0 ? aws_subnet.private_subnet[*].id : []
  description = "IDs of the private subnets"
}

output "tgw_private_subnet_ids" {
  value       = length(var.cidr_transit_gw_subnet_block) > 0 ? aws_subnet.tgw_private_subnet[*].id : []
  description = "IDs of the transit gateway private subnets"
}

output "private_data_store_subnet_ids" {
  value       = length(var.cidr_private_subnet_data_store_block) > 0 ? aws_subnet.private_data_store[*].id : []
  description = "IDs of the private data store subnets"
}

output "public_route_table_id" {
  value       = length(var.cidr_public_subnet_block) > 0 ? aws_route_table.public_route_table[0].id : null
  description = "ID of the public route table"
}

output "private_route_table_id" {
  value       = length(var.cidr_private_subnet_block) > 0 ? aws_route_table.private_route_table[0].id : null
  description = "ID of the private route table"
}

output "tgw_private_route_table_id" {
  value       = length(var.cidr_transit_gw_subnet_block) > 0 ? aws_route_table.tgw_private_route_table[0].id : null
  description = "ID of the TGW private route table"
}

output "private_data_store_route_table_id" {
  value       = length(var.cidr_private_subnet_data_store_block) > 0 ? aws_route_table.private_data_store_route_table[0].id : null
  description = "ID of the private data store route table"
}

output "igw_id" {
  value       = length(var.cidr_public_subnet_block) > 0 ? aws_internet_gateway.igw[0].id : null
  description = "ID of the Internet Gateway"
}

output "nat_gateway_id" {
  value       = length(var.cidr_public_subnet_block) > 0 ? aws_nat_gateway.nat[0].id : null
  description = "ID of the NAT Gateway"
}

output "nat_eip" {
  value       = length(var.cidr_public_subnet_block) > 0 ? aws_eip.nat[0].id : null
  description = "EIP for the NAT Gateway"
}
