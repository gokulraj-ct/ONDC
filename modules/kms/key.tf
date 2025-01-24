data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region       = data.aws_region.current.name
  descriptions = { for name in var.service_name : name => "${var.environment}-${name}-key" }
  tags         = { for name in var.service_name : name => {
    service_name = name
    environment  = var.environment
  } }
}

data "aws_region" "current" {}

resource "aws_kms_key" "this" {
  for_each                        = var.create_key ? tomap(local.descriptions) : {}
  deletion_window_in_days         = var.deletion_window_in_days
  description                     = each.value
  # policy                          = coalesce(var.policy, data.aws_iam_policy_document.this[0].json)
  tags                            = local.tags[each.key]
}

resource "aws_kms_alias" "this" {
  for_each = var.create_key ? toset(var.service_name) : toset([])

  name          = "alias/dev/${each.value}"
  target_key_id = aws_kms_key.this[each.key].key_id
}