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
    for subnet in module.vpc.pub_subs : {
      name = subnet.tags["Name"]
      id   = subnet.id,
      cidr = subnet.cidr_block
      az   = subnet.availability_zone
    }
  ]
}
