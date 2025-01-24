# Dev TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "ondc-tgw-vpn-route-table" {
  transit_gateway_id = var.tgw_id
  tags = {
    "Name"        = "ondc-tgw-vpn-route-table"
    "Environment" = "shared"
  }
}

# Association of VPN Attachments with the respective TGW Route Tables

# VPN Association
resource "aws_ec2_transit_gateway_route_table_association" "vpn_tgw_rt_association" {
  transit_gateway_attachment_id = var.vpn_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-vpn-route-table.id
}

# Propagation of traffic into the VPN TGW route table

# Shared VPC Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "shared_tgw_propagation" {
  transit_gateway_attachment_id = var.shared_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-vpn-route-table.id
}

# Dev VPC Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "dev_tgw_propagation" {
  transit_gateway_attachment_id = var.dev_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-vpn-route-table.id
}

# Pre-Prod VPC Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "pre_prod_tgw_propagation" {
  transit_gateway_attachment_id = var.pre_prod_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-vpn-route-table.id
}

# Prod VPC Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "prod_tgw_propagation" {
  transit_gateway_attachment_id = var.prod_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-vpn-route-table.id
}
