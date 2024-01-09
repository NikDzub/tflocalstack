resource "aws_subnet" "public_subnet_az1" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.dev_vpc
  cidr_block = element(var.public_subnet_cidrs, count.index)
 
  tags = {
    Name = "Public Subnet ${count.index + 1}"
 }
}
