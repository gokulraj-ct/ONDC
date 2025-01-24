# Define the environment variable
variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}

# Define the VPC ID for TGW attachment
variable "vpc_id" {
  description = "VPC ID for Transit Gateway attachment"
  type        = string
}

# Define the Subnet IDs for TGW attachment
variable "subnet_ids" {
  description = "List of Subnet IDs for Transit Gateway VPC attachment"
  type        = list(string)
}

# tgw id
variable "tgw_id" {
  description = "List of IDs for Transit Gateway "
  type        = string
}