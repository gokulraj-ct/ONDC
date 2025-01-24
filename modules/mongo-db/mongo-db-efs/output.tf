output "efs_id" {
  value = aws_efs_file_system.mongodb.id
}

output "efs_arn" {
  value = aws_efs_file_system.mongodb.arn
}
