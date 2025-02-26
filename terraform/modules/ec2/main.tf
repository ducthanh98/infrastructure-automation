resource "aws_instance" "bastion" {
  ami           = "ami-0672fd5b9210aa093"  # Chọn AMI phù hợp (Amazon Linux, Ubuntu, v.v.)
  instance_type = "t2.micro"  # Free Tier
  subnet_id     = var.public_subnets[0]
  key_name      = "thanhld"
  

  vpc_security_group_ids = [var.bastion_sg]

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = "${var.project_id}-bastion-host"
    project_id = var.project_id
  }
}

resource "aws_eip_association" "bastion_association" {
  instance_id = aws_instance.bastion.id
  allocation_id = var.bastion_eip
}