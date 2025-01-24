# Shared TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "ondc-tgw-shared-route-table" {
  transit_gateway_id = var.tgw_id
  tags = {
    "Name"        = "ondc-tgw-shared-route-table"
    "Environment" = var.env
  }
}

# Dev TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "ondc-tgw-dev-route-table" {
  transit_gateway_id = var.tgw_id
  tags = {
    "Name"        = "ondc-tgw-dev-route-table"
    "Environment" = "dev"
  }
}

# Pre-Prod TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "ondc-tgw-pre-prod-route-table" {
  transit_gateway_id = var.tgw_id
  tags = {
    "Name"        = "ondc-tgw-pre-prod-route-table"
    "Environment" = "pre-prod"
  }
}

# Prod TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "ondc-tgw-prod-route-table" {
  transit_gateway_id = var.tgw_id
  tags = {
    "Name"        = "ondc-tgw-prod-route-table"
    "Environment" = "prod"
  }
}

# Root TGW Route Table
resource "aws_ec2_transit_gateway_route_table" "ondc-tgw-root-route-table" {
  transit_gateway_id = var.tgw_id
  tags = {
    "Name"        = "ondc-tgw-root-route-table"
    "Environment" = "shared"
  }
}

# Association of VPC Attachments with the respective TGW Route Tables

# Shared VPC Attachment
resource "aws_ec2_transit_gateway_route_table_association" "shared_tgw_rt_association" {
  transit_gateway_attachment_id = var.shared_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-shared-route-table.id
}

# Dev VPC Attachment
resource "aws_ec2_transit_gateway_route_table_association" "dev_tgw_rt_association" {
  transit_gateway_attachment_id = var.dev_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-dev-route-table.id
}

# Pre-Prod VPC Attachment
resource "aws_ec2_transit_gateway_route_table_association" "pre_prod_tgw_rt_association" {
  transit_gateway_attachment_id = var.pre_prod_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-pre-prod-route-table.id
}

# Prod VPC Attachment
resource "aws_ec2_transit_gateway_route_table_association" "prod_tgw_rt_association" {
  transit_gateway_attachment_id = var.prod_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-prod-route-table.id
}

# Root VPC Attachment
resource "aws_ec2_transit_gateway_route_table_association" "root_tgw_rt_association" {
  transit_gateway_attachment_id = var.root_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-root-route-table.id
}

# Propagation of traffic into the shared TGW route table

# Dev VPC Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "dev_tgw_propagation" {
  transit_gateway_attachment_id = var.dev_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-shared-route-table.id
}

# Pre-Prod VPC Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "pre_prod_tgw_propagation" {
  transit_gateway_attachment_id = var.pre_prod_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-shared-route-table.id
}

# Prod VPC Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "prod_tgw_propagation" {
  transit_gateway_attachment_id = var.prod_vpc_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-shared-route-table.id
}

# VPN Propagation
resource "aws_ec2_transit_gateway_route_table_propagation" "vpn_tgw_propagation" {
  transit_gateway_attachment_id = var.vpn_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.ondc-tgw-shared-route-table.id
}

