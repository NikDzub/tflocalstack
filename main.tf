module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  az_count              = var.az_count
  pub_sub_per_az_count  = var.pub_sub_per_az_count
  priv_sub_per_az_count = var.priv_sub_per_az_count
}

module "nat_gateway" {
  source = "./modules/nat_gateway"

  vpc_id   = module.vpc.main.vpc_id
  az_count = module.vpc.main.az_count
  igw      = module.vpc.main.igw
}
