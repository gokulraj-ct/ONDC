variable "env" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "ou_arns" {
  type        = list(string)
  description = "List of Organizational Unit ARNs to share the TGW with"
}

variable "tgw_id" {
  type        = string
  description = "The ID of the existing Transit Gateway to share"
}
