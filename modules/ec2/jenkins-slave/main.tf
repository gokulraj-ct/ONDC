
# Launch Template for Jenkins slave
resource "aws_launch_template" "jenkins_slave_lt" {
  count         = var.role == "slave-shared" ? 1 : 0
  name_prefix   = "jenkins-slave-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name = "jenkins_slave_key"
  iam_instance_profile {
    name = "ec2_ssm_instance_profile"
  }
  network_interfaces {
    security_groups = [var.security_group_ids]
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              # Install necessary packages
              yum update -y
              yum install -y nfs-utils
              EOF
  )
}

# Jenkins slave Auto Scaling Group using Launch Template
resource "aws_autoscaling_group" "jenkins_slave_asg" {
  count             = var.role == "slave-shared" ? 1 : 0
  desired_capacity  = 1
  max_size          = 3
  min_size          = 1
  vpc_zone_identifier = [var.subnet_id]

  # Reference the Launch Template instead of Launch Configuration
  launch_template {
    id      = aws_launch_template.jenkins_slave_lt[0].id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Jenkins-slave"
    propagate_at_launch = true
  }
}


# resource "aws_key_pair" "jenkins_key" {
#   key_name   = "jenkins_key"
#   public_key = tls_private_key.rsa.public_key_openssh
# }

# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "jenkins_local_key" {
#     content  = tls_private_key.rsa.private_key_pem
#     filename = "jenkins_key"
# }

