resource "aws_security_group" "jenkins_master_sg" {
  vpc_id = var.vpc_id
  # name = "jenkins_master_sg_orig"
  ingress {
    from_port   = 8080  # Jenkins default port
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  }

  ingress {
      from_port   = 2049  # Jenkins default port
      to_port     = 2049
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  }

  ingress {
    from_port   = 22  # Jenkins default port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  }

  ingress {
    from_port   = 8080  # Jenkins default port
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  # Adjust to restrict access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-jenkins-master-sg-orig"
    Environment = var.environment
  }
}

# Security group for EFS to allow NFS access
resource "aws_security_group" "efs_sg" {
  vpc_id = var.vpc_id
  # name = "efs_sg_orig"
  ingress {
    from_port     = 2049
    to_port       = 2049
    protocol      = "tcp"
    security_groups = [aws_security_group.jenkins_master_sg.id]  # Reference to Jenkins master SG
  }

  tags = {
    Name        = "${var.environment}-efs-sg-orig"
    Environment = var.environment
  }
}


resource "aws_security_group" "atlantis_sonarqube_sg" {
  vpc_id = var.vpc_id
  # name = "atlantis_sonarqube_sg_orig"
  # ingress {
  #   from_port   = 0  # Jenkins default port
  #   to_port     = 0
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  # }

  ingress {
    from_port   = 22  # Jenkins default port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  }

  ingress {
    from_port   = 4141  # Jenkins default port
    to_port     = 4141
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  }

  ingress {
    from_port   = 9000  # Jenkins default port
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  }

  # ingress {
  #   from_port   = 80  # Jenkins default port
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  # }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-atlantis-sonar-sg-orig"
    Environment = var.environment
  }
}


resource "aws_security_group" "jenkins_slave_sg" {
  vpc_id = var.vpc_id
  # name = "jenkins_slave_sg_orig"
  ingress {
    from_port   = 8080  # Jenkins default port
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Adjust to restrict access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-jenkins-master-sg-orig"
    Environment = var.environment
  }
}