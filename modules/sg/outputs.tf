output "efs_sg" {
  value = aws_security_group.efs_sg.id
}

output "jenkins_master_sg" {
  value = aws_security_group.jenkins_master_sg.id
}

output "atlantis_sonarqube_sg" {
  value = aws_security_group.atlantis_sonarqube_sg.id
}

output "jenkins_slave_sg" {
  value = aws_security_group.jenkins_slave_sg.id
}