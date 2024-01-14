output "pub_subs" {
  value = [
    for subnet in module.vpc.pub_subs : {
      subnet_name       = subnet.tags["Name"]
      subnet_id         = subnet.id,
      cidr              = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  ]
}
output "priv_subs" {
  value = [
    for subnet in module.vpc.priv_subs : {
      subnet_name       = subnet.tags["Name"]
      subnet_id         = subnet.id,
      cidr              = subnet.cidr_block
      availability_zone = subnet.availability_zone
    }
  ]
}

output "priv_route_tables" {
  value = [
    for table in module.vpc.priv_route_tables : {
      private_table_name = table.tags["Name"]
      private_table_id   = table.id
    }
  ]
}
output "pub_route_tables" {
  value = [
    for table in module.vpc.pub_route_tables : {
      public_table_name = table.tags["Name"]
      public_table_id   = table.id
    }
  ]
}

# output "pub_route_table_asso" {
#   value = [
#     for asso in module.vpc.pub_route_table_asso : {
#       route_table_id        = asso.route_table_id
#       association_id        = asso.id
#       association_subnet_id = asso.subnet_id
#     }
#   ]
# }
# output "priv_route_table_asso" {
#   value = [
#     for asso in module.vpc.priv_route_table_asso : {
#       route_table_id        = asso.route_table_id
#       association_id        = asso.id
#       association_subnet_id = asso.subnet_id
#     }
#   ]
# }
output "nat_gws" {
  value = [
    for gw in module.vpc.nat_gws : {
      nat_gw__name = gw.tags["Name"]
      public_ip    = gw.public_ip
      subnet_id    = gw.subnet_id
      nat_gw_id    = gw.id
    }
  ]

}
output "vpc_id" {
  value = module.vpc.vpc_id
}
