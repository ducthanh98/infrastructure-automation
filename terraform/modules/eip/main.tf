resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    project_id = var.project_id
    Name = "${var.project_id}-nat-eip"
  }
}