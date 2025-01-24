# Security group for EC2 instance
resource "aws_security_group" "ec2_sg" {
  name        = "ec2_mongodb_sg-v2"
  description = "Security group for MongoDB EC2 instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.jump_server_sg]
  }

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    security_groups = [var.eks_sg]
  }

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    security_groups = [var.efs_sg]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.env}-mongodb-sg-v2"
    Environment = var.env
  }
}