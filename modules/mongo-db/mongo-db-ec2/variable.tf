variable "env" {
  description = "The environment (e.g., dev, prod)"
  type        = string
}

variable "key_name" {
  description = "ec2 key pair"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID where the EC2 instance will be launched"
  type        = string
}

variable "mongo_sg_id" {
  description = "The subnet ID where the EC2 instance will be launched"
  type        = string
}


