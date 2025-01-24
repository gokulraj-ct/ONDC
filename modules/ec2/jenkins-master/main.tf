data "aws_iam_policy_document" "ssm_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ssm_role" {
  name               = "ec2_ssm_role"
  assume_role_policy = data.aws_iam_policy_document.ssm_role_policy.json
  description        = "The IAM role for SSM access to EC2 instances"
  tags = {
    Name = "ec2_ssm_role"
    Environment = "shared"
  }
}

resource "aws_iam_role_policy_attachment" "ssm_role_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ec2_ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
  tags = {
    Name = "ec2_ssm_instance_profile"
    Environment = "shared"
  }
}

# Jenkins master instance
resource "aws_instance" "jenkins_server" {
  count         = var.role == "master-shared" ? 1 : 0
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  iam_instance_profile = aws_iam_instance_profile.ssm_profile.name
  key_name = "jenkins_master_key"
  vpc_security_group_ids = [var.security_group_ids]
  tags = {
    Name = "Jenkins-${var.role}"
  }
  volume_tags = {
    Name      = "jenkins_efs"
    Terraform = "true"
  }
  user_data       = "${data.template_file.script.rendered}"
  # key_name = "jenkins-master-key.pem"
  # key_name = "${aws_key_pair.jenkins-master-key-pair.id}"
}

# resource "aws_key_pair" "jenkins-master-key-pair" {
#     key_name = "jenkins-master-key-pair"
#     public_key = "${file(var.public_key_path)}"
# }


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

resource "aws_efs_file_system" "efs" {
  availability_zone_name = "ap-south-1a"
  creation_token   = "jenkins_efs"
  performance_mode = "generalPurpose"
tags = {
    Name = "jenkins_efs"
    Environment = "shared"
  }
}

resource "aws_efs_mount_target" "efs" {
  depends_on = [ aws_efs_file_system.efs ]
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_id
  security_groups = [var.security_group_ids]
}

data "template_file" "script" {
  template = "${file("script.tpl")}"
  vars = {
    efs_id = aws_efs_file_system.efs.id
  }
}