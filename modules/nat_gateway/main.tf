resource "aws_eip" "eip4_nat_gw" {
  count  = length(var.az_count)
  domain = "vpc"

  tags = {
    Name = "eip4_nat_gw_az${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count = length(var.az_count)

  allocation_id = aws_eip.eip4_nat_gw[*].id
  subnet_id     = aws_subnet.example.id

  tags = {
    Name = "nat_gw_az_${count.index + 1}"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [var.igw]
}
