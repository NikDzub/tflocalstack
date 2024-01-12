output "nat_gateway_az1_public_ip" {
  value = aws_eip.eip_for_nat_gateway_az1.public_ip
}
output "nat_gateway_az2_public_ip" {
  value = aws_eip.eip_for_nat_gateway_az2.public_ip
}

