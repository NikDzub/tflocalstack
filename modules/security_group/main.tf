resource "aws_security_group" "main" {
  count = length(var.security_groups)

  name        = var.security_groups[count.index].name
  description = var.security_groups[count.index].description
  vpc_id      = var.security_groups[count.index].vpc_id

  dynamic "ingress" {
    for_each = var.security_groups[count.index].ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}
