output "jenkins_alb_dns_name" {
  description = "DNS name of the Jenkins ALB"
  value       = aws_lb.jenkins_alb.dns_name
}

output "alb_sg" {
  value = aws_security_group.alb_sg.id
}