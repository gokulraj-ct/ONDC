# EC2 instance definition
resource "aws_instance" "mongodb_server" {
  ami           = var.ami_id
  instance_type = "t3.large"
  subnet_id     = var.subnet_id

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

   key_name = var.key_name

  tags = {
    Name        = "${var.env}-mongodb-server"
    Environment = var.env
  }

  vpc_security_group_ids = [var.mongo_sg_id]
  associate_public_ip_address = false
}

