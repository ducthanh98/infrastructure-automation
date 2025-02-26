output "natgw_ip" {
  value = aws_eip.nat_eip.id
}

output "bastion_eip" {
  value = aws_eip.bastion_ip.id
}