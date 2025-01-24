variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
}

variable "cidr_public_subnet_block" {
  description = "The CIDR blocks for the public subnets"
  type        = list(string)
}

variable "cidr_private_subnet_block" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "cidr_private_subnet_data_store_block" {
  description = "The CIDR blocks for the private subnets"
  type        = list(string)
}

variable "cidr_transit_gw_subnet_block" {
  description = "The CIDR blocks for the TGW private subnets"
  type        = list(string)
}

variable "region" {
  description = "The availability zones for the subnets"
  type        = list(string)
}

variable "env" {
  description = "A label to differentiate the environment"
  type        = string
}

variable "description" {
  description = "A description for the resources"
  type        = string
}
