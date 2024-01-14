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
      // Add more ingress rule attributes as needed
    }))
    // Add more security group attributes as needed
  }))
}


