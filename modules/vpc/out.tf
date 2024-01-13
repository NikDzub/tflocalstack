output "vpc_id" {
  value = aws_vpc.main.id
}
output "pub_subs" {
  value = aws_subnet.pub_sub

}
output "priv_subs" {
  value = aws_subnet.priv_sub

}
