those are screen shots from a tutorial  
https://www.youtube.com/watch?v=ZP_vAbjfFMs  

1.  
screenshot 1 -
![1](https://github.com/NikDzub/tflocalstack/assets/87159434/32317619-4313-4c72-a1b2-1717a887ff67)
https://github.com/NikDzub/tflocalstack/blob/master/modules/vpc/main.tf  

multiple resources for kinda the same thing(aws_subnet)  
acceptable? considered as best practice?  

screenshots 2, 3 -  
![2](https://github.com/NikDzub/tflocalstack/assets/87159434/5d4c8455-5767-485a-ab95-b9495f1da3e4)
![3](https://github.com/NikDzub/tflocalstack/assets/87159434/cebd7c5e-e0af-4348-98f9-336e78f4fcdf)

its the "main" `main.tf` file, thats how it should look like? (for a vpc project)  
because in my `main.tf` the vpc module is like this:  
```
module "vpc" {
  source = "./modules/vpc"
  project_name          = var.project_name
  az_count              = var.az_count
  pub_sub_per_az_count  = var.pub_sub_per_az_count
  priv_sub_per_az_count = var.priv_sub_per_az_count
}
```
i guess as a terraform begginer that hes approach is better  
but its just seem more hardcoded than mine.  

2.  
https://github.com/NikDzub/tflocalstack/blob/master/main.tf#L10
while adding the security groups  
i was thinking to make a a variable `./modules/security_groups/variables.tf`  
```
variable "security_groups" {
  type = list(object({
    name        = string
    description = string
    vpc_id      = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
```
and then in :  
```
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
          cidr_blocks = ["my.ip.addr"] <<<<<<<<<<<<<<<<<<<<<<<
          security_groups = [] <<<<<<<<<<<<<<<<<<<<<<<<
        },
      ]
    },
  ]
}
```
to create them, but it seems wrong right?  
because in a few security groups i need to reference another security group id (before it "exists")  

so the best approach is just to make a "aws_security_group" resource for each security group in `/modules/security_group/main.tf`?  

