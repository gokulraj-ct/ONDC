locals {
  region = data.aws_region.current.name
  tags = {
    environment = var.environment
  }
  # Decode the kms_key_id JSON string into a map
  kms_key_map = jsondecode(var.kms_key_id)

}

data "aws_region" "current" {}

# resource "aws_secretsmanager_secret" "this" {
#   for_each = var.create ? toset(var.service_names) : {}

#   description             = var.description
#   kms_key_id              = var.kms_key_id
#   name                    = "${var.environment}/${each.value}-secret"
#   recovery_window_in_days = var.recovery_window_in_days

#   tags = merge(local.tags, { service_name = each.value })
# }

resource "aws_secretsmanager_secret" "this" {
  for_each = var.create ? toset(var.service_names) : toset([])  # Use toset([]) instead of {}

  description             = var.description
  kms_key_id              = local.kms_key_map[each.value]  # Fetch the key_id dynamically from the decoded map
  name                    = "${var.environment}/${each.value}-secret"
  recovery_window_in_days = var.recovery_window_in_days

  tags = merge(local.tags, { service_name = each.value })
}

