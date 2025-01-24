variable "instance_type" {
  description = "Instance type for Jenkins server"
  type        = string
  default     = "t3.medium"
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = "subnet-0e19fec429bb68a65"  # Replace with your actual subnet ID
}

# variable "public_key_path" {
#   description = "public_key_path"
#   # type        = string
#   default = "~/.ssh/id_rsa.pub" # Replace this with a path to your public key}
# }

# variable "efs_file_system_id" {
#   description = "EFS file system ID"
#   type        = string
#   default     = "fs-0064415c66ccdd635"  # Replace with your EFS ID
# }

variable "security_group_ids" {
  description = "Security Group IDs for Jenkins servers"
  type        = string
  # default     = ["sg-0e5123f7348e1f791"]  # Replace with your security group ID
}

variable "ami_id" {
  description = "AMI ID for Jenkins server"
  type        = string
  default     = "ami-08bf489a05e916bbd"  # Replace with your AMI ID
}

variable "role" {
  description = "Role of the server (master or slave)"
  type        = string
  # default     = "master"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
