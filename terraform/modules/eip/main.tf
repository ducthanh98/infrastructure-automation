resource "aws_eip" "nat_eip" {
  tags = {
    project_id = var.project_id
    Name = "${var.project_id}-nat-eip"
  }
}

resource "aws_eip" "bastion_ip" {
  tags = {
    project_id = var.project_id
    Name = "${var.project_id}-bastion-eip"
  }
}