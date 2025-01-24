locals {
  region          = var.region
  environment     = var.environment
  # azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  subnet_ids = var.subnet_id
  az = var.az
  vpc_id = var.vpc_id
  tags = {
    environment  = var.environment
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 8080  # Jenkins default port
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow traffic from private subnet
  }

  ingress {
    from_port   = 9000  # Jenkins default port
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow traffic from private subnet
  }

  ingress {
    from_port   = 4141  # Jenkins default port
    to_port     = 4141
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Allow traffic from private subnet
  }

  ingress {
    from_port   = 80  # Jenkins default port
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from private subnet
  }
  ingress {
    from_port   = 443  # Jenkins default port
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from private subnet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "jenkins_alb" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnet_id

  tags = {
    Name        = "${var.environment}-common-alb"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "jenkins_target_group" {
  name        = "${var.environment}-jenkins-tg"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/login"
    protocol            = "HTTP"
    port                = "8080"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.environment}-jenkins-tg"
    Environment = var.environment
  }
}


resource "aws_lb_target_group" "atlantis_target_group" {
  name        = "${var.environment}-atlantis-tg"
  port        = 4141
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "4141"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.environment}-atlantis-tg"
    Environment = var.environment
  }
}

resource "aws_lb_target_group" "sonarqube_target_group" {
  name        = "${var.environment}-sonarqube-tg"
  port        = 9000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "9000"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "${var.environment}-sonarqube-tg"
    Environment = var.environment
  }
}

resource "aws_lb_target_group_attachment" "jenkins_instance_attachment" {
  target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  target_id        = var.jenkins_instance_id  # Jenkins EC2 instance ID
  port             = 8080
}


resource "aws_lb_target_group_attachment" "atlantis_instance_attachment" {
  target_group_arn = aws_lb_target_group.atlantis_target_group.arn
  target_id        = var.atlantis_sonarqube_instance_id  # Jenkins EC2 instance ID
  port             = 4141
}


resource "aws_lb_target_group_attachment" "sonarqube_instance_attachment" {
  target_group_arn = aws_lb_target_group.sonarqube_target_group.arn
  target_id        = var.atlantis_sonarqube_instance_id  # Jenkins EC2 instance ID
  port             = 9000
}



resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  }
}

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-south-1:577638354424:certificate/76ea1936-bd26-4089-b9ee-96073b446a28" 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  }
}


resource "aws_alb_listener_rule" "jenkins_rule" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 1
  
  condition {
    host_header {
      values = ["jenkins.ondc.tech"]
    }
  }
  depends_on = [ aws_lb_target_group.jenkins_target_group ]
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_target_group.arn
  }
}

resource "aws_alb_listener_rule" "sonarqube_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 2

  condition {
    host_header {
      values = ["sonarqube.ondc.tech"]
    }
  }
  depends_on = [ aws_lb_target_group.sonarqube_target_group ]
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sonarqube_target_group.arn
  }
}

resource "aws_alb_listener_rule" "atlantis_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 3

  condition {
    host_header {
      values = ["atlantis.ondc.tech"]
    }
  }
  depends_on = [ aws_lb_target_group.atlantis_target_group ]
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.atlantis_target_group.arn
  }
}