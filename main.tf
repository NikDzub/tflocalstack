module "vpc" {
  source = "./modules/vpc"

  project_name          = var.project_name
  az_count              = var.az_count
  pub_sub_per_az_count  = var.pub_sub_per_az_count
  priv_sub_per_az_count = var.priv_sub_per_az_count
}

module "security_groups" {
  source = "./modules/security_group"

  security_groups = [
    {
      name        = "alb_sg"
      description = "alb_sg"
      vpc_id      = module.vpc.vpc_id
      ingress_rules = [
        {
          from_port   = 80
          to_port     = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
        {
          from_port   = 443
          to_port     = 443
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        },
      ]
    },
    {
      name        = "ssh_sg"
      description = "ssh_sg"
      vpc_id      = module.vpc.vpc_id
      ingress_rules = [
        {
          from_port   = 22
          to_port     = 22
          protocol    = "tcp"
          cidr_blocks = ["10.0.0.0/16"] # my_ip..
          # security_groups = []
        },
      ]
    },
  ]
}
