# output "jenkins_master_id" {
#   value       = length(aws_instance.jenkins_server) > 0 ? aws_instance.jenkins_server[0].id : null
#   description = "ID of the Jenkins master instance"
# }

output "jenkins_slave_asg_id" {
  value       = length(aws_autoscaling_group.jenkins_slave_asg) > 0 ? aws_autoscaling_group.jenkins_slave_asg[0].id : null
  description = "ID of the Jenkins slave autoscaling group"
}
