output "natgw_ip" {
  value = aws_eip.nat_eip.id
}