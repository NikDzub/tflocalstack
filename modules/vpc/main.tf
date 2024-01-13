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

################## subnets ######################
resource "aws_subnet" "pub_sub" {
  count = var.az_count * var.pub_sub_per_az_count

  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.pub_sub_cidr_blocks, count.index)
  availability_zone       = element(data.aws_availability_zones.az.names, count.index % var.az_count)
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "priv_sub" {
  count = var.az_count * var.priv_sub_per_az_count

  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.priv_sub_cidr_blocks, count.index)
  availability_zone = element(data.aws_availability_zones.az.names, count.index % var.az_count)
  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}

################## route table #####################
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "public route table" }
}

resource "aws_route_table" "priv_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "pub_sub_asso" {
  count          = length(aws_subnet.pub_sub)
  subnet_id      = aws_subnet.pub_sub[count.index].id
  route_table_id = aws_route_table.pub_rt.id
}

resource "aws_route_table_association" "priv_sub_asso" {
  count          = length(aws_subnet.priv_sub)
  subnet_id      = aws_subnet.priv_sub[count.index].id
  route_table_id = aws_route_table.priv_rt.id
}


