# variables.tf
variable "env" {
  description = "The env of the EFS file system"
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID where the EFS will be created"
  type        = string
}
  
variable "efs_allowed_security_groups" {
  description = "List of security groups allowed to access EFS"
  type        = list(string)
  default     = []  # You can set a default list if needed
}

