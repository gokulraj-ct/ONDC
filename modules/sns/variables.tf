variable "sns_topic_name"{
  description  = "SNS topic name"
  type         = string
  default      = "pramaan"
}

variable "sns_subscription_protocol"{
  description  = "SNS subscription protocol"
  type         = string
  default      = "email"
}

variable "sns_endpoint"{
  description  = "sns endpoint"
  type         = string
  default      = "gokul.r@cloudthat.com"
}
