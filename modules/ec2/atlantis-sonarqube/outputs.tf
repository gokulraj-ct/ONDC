output "atlantis_id" {
  value       = aws_instance.atlantis_server.id
  description = "ID of the atlantis master instance"
}