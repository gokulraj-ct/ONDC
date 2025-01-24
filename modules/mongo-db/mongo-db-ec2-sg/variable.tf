variable "vpc_id" {
  description = "The VPC ID where the resources will be created"
  type        = string
}

variable "env" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "eks_sg" {
  description = "The sg to connect to eks"
  type        = string
}

variable "efs_sg" {
  description = "The sg to connect to efs"
  type        = string
}

variable "jump_server_sg" {
  description = "The sg to connect to efs"
  type        = string
}

