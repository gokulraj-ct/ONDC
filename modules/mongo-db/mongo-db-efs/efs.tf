# Terragrunt module for AWS EFS

# Main EFS resource definition
resource "aws_efs_file_system" "mongodb" {
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  encrypted   = true
  throughput_mode = "elastic"

  tags = {
    "Name"          = "${var.env}-efs"
    Environment     = var.env
  }
}

# Backup policy
resource "aws_efs_backup_policy" "mongodb_backup" {
  file_system_id = aws_efs_file_system.mongodb.id

  backup_policy {
    status = "ENABLED"
  }
}

# Mount targets for each subnet
resource "aws_efs_mount_target" "mongodb" {
  for_each       = toset(var.subnet_ids)
  file_system_id = aws_efs_file_system.mongodb.id
  subnet_id      = each.value
  security_groups = var.security_group_ids
}