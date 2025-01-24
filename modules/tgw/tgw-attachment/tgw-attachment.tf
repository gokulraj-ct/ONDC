## Attachement of VPC to the tgw shared
resource "aws_ec2_transit_gateway_vpc_attachment" "ondc-vpc-attachment" {
  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  transit_gateway_id = var.tgw_id

  appliance_mode_support = "enable"
  dns_support            = "enable" 
  tags = {
    "Name"          = "ondc-tgw-attachment"
    Environment     = var.env
  }
}