locals {
  jenkins_master_asg_tags = merge(
    var.tags,
    { "Name" = "${var.environment}-${var.application}-master-asg"  }
  )
}

# resource "aws_iam_instance_profile" "instance_profile" {
#   name = "${var.environment}-${var.application}-instance-profile"

#   role = var.iam_role
# }

resource "aws_launch_template" "application_lt" {
  name_prefix   = "${var.environment}-${var.application}-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    arn = "arn:aws:iam::577638354424:instance-profile/ec2_ssm_instance_profile"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 50
      volume_type = "gp3"
      delete_on_termination = false
      encrypted = "false"
      throughput = 125
      iops = 3000
      # snapshot_id           = "snap-056d1d1048bfdd499"
    }
  }

  network_interfaces {
    associate_public_ip_address = var.public_access
    security_groups             = [aws_security_group.jenkins_master_sg.id]
  }

  user_data = base64encode(var.user_data)

}

resource "aws_autoscaling_group" "jenkins_master_asg" {
  name                = "${var.environment}-${var.application}-master-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  health_check_type         = "EC2"
  vpc_zone_identifier = var.asg_subnets

  launch_template {
    id      = aws_launch_template.application_lt.id
    version = aws_launch_template.application_lt.latest_version
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  dynamic "tag" {
    for_each = local.jenkins_master_asg_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }


}

resource "aws_autoscaling_attachment" "jenkins_master_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.jenkins_master_asg.name
  lb_target_group_arn   = "arn:aws:elasticloadbalancing:ap-south-1:577638354424:targetgroup/shared-jenkins-tg/aa5c1b1664306dc4"
}

# output "auto_scaling_group_name" {
#   description = "Auto scaling group name"
#   value = aws_autoscaling_group.jenkins_master_asg.name
# }

# output "launch_template_id" {
#   description = " launch template id"
#   value = aws_launch_template.application_lt.id
# }
