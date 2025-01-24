variable "tgw_id" {
  description = "The ID of the Transit Gateway"
  type        = string
}

variable "shared_vpc_attachment_id" {
  description = "The attachment ID for the shared VPC"
  type        = string
}

variable "dev_vpc_attachment_id" {
  description = "The attachment ID for the dev VPC"
  type        = string
}

variable "pre_prod_vpc_attachment_id" {
  description = "The attachment ID for the pre-prod VPC"
  type        = string
}

variable "prod_vpc_attachment_id" {
  description = "The attachment ID for the prod VPC"
  type        = string
}

variable "root_vpc_attachment_id" {
  description = "The attachment ID for the root VPC"
  type        = string
}

variable "vpn_attachment_id" {
  description = "The attachment ID for the VPN"
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, pre-prod, prod)"
  type        = string
}
