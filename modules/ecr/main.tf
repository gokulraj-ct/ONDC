resource "aws_ecr_repository" "ecr_repository" {
  for_each = toset(var.names)

  name                 = each.value
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  tags = merge(
    var.additional_tags,
    {
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  )
}

