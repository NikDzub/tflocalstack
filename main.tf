module "vpc" {
  source       = "./modules/vpc"
  project_name = var.project_name

  az_count              = var.az_count
  pub_sub_per_az_count  = var.pub_sub_per_az_count
  priv_sub_per_az_count = var.priv_sub_per_az_count
}
