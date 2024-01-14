data "aws_availability_zones" "az" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}_vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}_igw"
  }
}

################## sub ######################
resource "aws_subnet" "pub_sub" {
  count = var.az_count * var.pub_sub_per_az_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.pub_sub_cidr_blocks, count.index)
  availability_zone       = element(data.aws_availability_zones.az.names, count.index % var.az_count)
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "priv_sub" {
  count = var.az_count * var.priv_sub_per_az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.priv_sub_cidr_blocks, count.index)
  availability_zone = element(data.aws_availability_zones.az.names, count.index % var.az_count)
  tags = {
    Name = "private_subnet_${count.index + 1}"
  }
}

################## rt #####################
resource "aws_route_table" "pub_rt" {
  count  = 1
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public_route_table_${count.index + 1}" }
}

resource "aws_route_table" "priv_rt" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id
  tags   = { Name = "private_route_table_${count.index + 1}" }

}

resource "aws_route_table_association" "pub_sub_asso" {
  count          = length(aws_subnet.pub_sub)
  subnet_id      = aws_subnet.pub_sub[count.index].id
  route_table_id = element(aws_route_table.pub_rt[*].id, count.index)

}

resource "aws_route_table_association" "priv_sub_asso" {
  count          = length(aws_subnet.priv_sub)
  subnet_id      = aws_subnet.priv_sub[count.index].id
  route_table_id = element(aws_route_table.priv_rt[*].id, count.index)
}

################## nat #####################
resource "aws_eip" "eip4_nat_gw" {
  count = var.az_count

  domain = "vpc"
  tags = {
    Name = "eip4_nat_gw_az${count.index + 1}"
  }
}

resource "aws_nat_gateway" "main" {
  count = var.az_count

  allocation_id = aws_eip.eip4_nat_gw[count.index].id
  subnet_id     = aws_subnet.pub_sub[count.index].id
  depends_on    = [aws_internet_gateway.igw]
  tags = {
    Name = "nat_gw_az_${count.index + 1}"
  }
}



