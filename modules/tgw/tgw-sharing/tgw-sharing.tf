# Create the TGW resource share
resource "aws_ram_resource_share" "ondc-tgw-share" {
  name                      = "ondc-tgw-share"
  allow_external_principals = false

  tags = {
    "Name"            = "ondc-tgw-share"
    "Environment"     = var.env
  }
}

# Data source to reference an existing Transit Gateway
data "aws_ec2_transit_gateway" "ondc_tgw" {
  filter {
    name   = "transit-gateway-id"
    values = [var.tgw_id]
  }
}


# Attach TGW to the resource share
resource "aws_ram_resource_association" "ondc-resource-association" {
  resource_arn       = data.aws_ec2_transit_gateway.ondc_tgw.arn
  resource_share_arn = aws_ram_resource_share.ondc-tgw-share.arn
}

# Loop over the list of OU ARNs to share TGW
resource "aws_ram_principal_association" "ondc-ou-association" {
  count              = length(var.ou_arns)
  principal          = var.ou_arns[count.index]
  resource_share_arn = aws_ram_resource_share.ondc-tgw-share.arn
}