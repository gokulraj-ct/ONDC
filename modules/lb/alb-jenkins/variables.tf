variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "subnet_id" {
  description = "List of subnets for ALB"
  type        = list(string)
}

# variable "alb_security_group_id" {
#   description = "Security group ID for the ALB"
#   type        = string
# }

variable "environment" {
  description = "Environment for resource naming"
  type        = string
}

variable "jenkins_instance_id" {
  description = "ID of the Jenkins EC2 instance to attach to the ALB"
  type        = string
}

variable "atlantis_sonarqube_instance_id" {
  description = "ID of the Atlantis Sonarqube EC2 instance to attach to the ALB"
  type        = string
}

variable "region" {
  type = string
}
variable "az" {
  type = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1a"]
}