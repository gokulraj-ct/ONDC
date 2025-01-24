# infra-modules/efs/variables.tf

variable "region" {
  description = "The AWS region where the EFS will be created."
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EFS will be created."
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the EFS mount targets will be created."
  type        = list(string)
}

variable "environment" {
  description = "The environment for which the resources are being created (e.g., dev, staging, prod)."
  type        = string
}
