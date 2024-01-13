output "vpc_id" {
  value = module.vpc.vpc_id
}
output "pub_subs" {
  value = [
    for subnet in module.vpc.pub_subs : {
      name = subnet.tags["Name"]
      id   = subnet.id,
      cidr = subnet.cidr_block
      az   = subnet.availability_zone
    }
  ]
}
output "priv_subs" {
  value = [
    for subnet in module.vpc.priv_subs : {
      name = subnet.tags["Name"]
      id   = subnet.id,
      cidr = subnet.cidr_block
      az   = subnet.availability_zone
    }
  ]
}
output "pub_route_table" {
  value = [
    for asso in module.vpc.pub_route_table : {
      id     = asso.id
      sub_id = asso.subnet_id
    }
  ]
}
output "priv_route_table" {
  value = [
    for asso in module.vpc.priv_route_table : {
      id     = asso.id
      sub_id = asso.subnet_id
    }
  ]
}

