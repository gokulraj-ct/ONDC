# variables.tf
variable "env" {
  description = "The env of the EFS file system"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EFS will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EFS mount targets"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs to attach to the EFS mount targets"
  type        = list(string)
}
