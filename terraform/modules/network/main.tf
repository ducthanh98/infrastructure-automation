// available zones
data "aws_availability_zones" "available" {}



resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_id}-vpc"
    project_id = var.project_id
  }
}
 
// Subnets
// Public subnets

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id

  for_each = { for idx, cidr in var.public_subnets: idx => cidr}

  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key]

  tags = {
    Name = "${var.project_id}-public-subnet-${data.aws_availability_zones.available.names[each.key]}"
    project_id = var.project_id
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.main.id

  for_each = { for idx, cidr in var.private_subnets: idx => cidr}

  cidr_block = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key]


  tags = {
    Name = "${var.project_id}-private-subnet-${data.aws_availability_zones.available.names[each.key]}"
    project_id = var.project_id
  }
}


// Internet gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_id}-gw"
    project_id = var.project_id
  }
}

// Public Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.project_id}-rt"
    project_id = var.project_id
  }
}

resource "aws_route_table_association" "public_rt_association" {
  for_each = aws_subnet.public_subnet

  route_table_id = aws_route_table.public_rt.id
  subnet_id = each.value.id
}

// Nat gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = var.nat_eip
  subnet_id     = aws_subnet.public_subnet[0].id
  tags = { 
    Name = "${var.project_id}-nat-gateway" 
  }
}

// private rt
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_id}-private-rt"
    project_id = var.project_id
  }
}

# Chuyển tất cả traffic ra ngoài thông qua NAT Gateway
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}

# Gán Route Table vào Private Subnets
resource "aws_route_table_association" "private_subnet_association" {
  for_each = aws_subnet.private_subnet

  route_table_id = aws_route_table.private_rt.id
  subnet_id = each.value.id
}


