

# resource "aws_launch_template" "atlantis" {
#   name_prefix   = "atlantis-"
#   image_id      = var.ami_id
#   instance_type = var.instance_type
#   key_name      = var.key_name

#   user_data = base64encode(<<-EOF
#               #!/bin/bash
#               yum update -y
#               yum install -y amazon-efs-utils
#               echo 'export GOPATH=$HOME/go' >> ~/.bash_profile
#               echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bash_profile
#               go install github.com/runatlantis/atlantis@latest
#               EOF
#   )

#   # No tags block here; tags are applied in the Auto Scaling Group
# }

resource "aws_instance" "atlantis_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [var.security_group_ids]
  key_name = "atlantis_sonarqube_key"
  iam_instance_profile = "ec2_ssm_instance_profile"
#userdata
  user_data = <<-EOF
              #!/bin/bash
              # Install necessary packages
              yum update -y
              echo 'export GOPATH=$HOME/go' >> ~/.bash_profile
              echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bash_profile
              go install github.com/runatlantis/atlantis@lates
              
              EOF
  tags = {
    Name = "atlantis-sonarqube"
  }
}

# resource "aws_key_pair" "atlantis_sonarqube_key" {
#   key_name   = "atlantis_sonarqube_key"
#   public_key = tls_private_key.rsa.public_key_openssh
# }

# resource "tls_private_key" "rsa" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "local_file" "atlantis_sonarqube_local_key" {
#     content  = tls_private_key.rsa.private_key_pem
#     filename = "atlantis_sonarqube_key"
# }
