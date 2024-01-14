output "vpc_id" {
  value = aws_vpc.main.id
}
output "pub_subs" {
  value = aws_subnet.pub_sub
}
output "priv_subs" {
  value = aws_subnet.priv_sub
}
output "priv_route_tables" {
  value = aws_route_table.priv_rt
}
output "pub_route_tables" {
  value = aws_route_table.pub_rt
}
output "priv_route_table_asso" {
  value = aws_route_table_association.priv_sub_asso
}
output "pub_route_table_asso" {
  value = aws_route_table_association.pub_sub_asso
}
output "nat_gws" {
  value = aws_nat_gateway.main
}
