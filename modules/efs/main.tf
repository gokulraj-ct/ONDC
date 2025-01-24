resource "aws_efs_file_system" "efs" {
  availability_zone_name = "ap-south-1a"
  creation_token   = "jenkins"
  performance_mode = "generalPurpose"
tags = {
    Name = "jenkins"
    Environment = "shared"
  }
}

resource "aws_efs_mount_target" "efs" {
  depends_on = [ aws_efs_file_system.efs ]
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_ids]
}

# data "template_file" "script" {
#   template = "${file("script.tpl")}"
#   vars = {
#     efs_id = aws_efs_file_system.efs.id
#   }
# }