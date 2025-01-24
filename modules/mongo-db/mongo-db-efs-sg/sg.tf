resource "aws_security_group" "efs_sg" {
  name        = "efs_mount_target_sg"
  description = "Security group for EFS mount targets"
  vpc_id      = var.vpc_id

  # Dynamically create ingress rules for each SG in the list
  dynamic "ingress" {
    for_each = var.efs_allowed_security_groups
    content {
      from_port       = 2049
      to_port         = 2049
      protocol        = "tcp"
      security_groups = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"          = "${var.env}-efs_mount_target_sg"
    Environment     = var.env
  }
}
