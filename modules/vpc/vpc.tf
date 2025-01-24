resource "aws_vpc" "test" {
  cidr_block = var.cidr_block
  
  #enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name        = "${var.env}-vpc"
    description = var.description
  }
}

resource "aws_subnet" "public_subnet" {
  count             = length(var.cidr_public_subnet_block) > 0 ? length(var.cidr_public_subnet_block) : 0
  vpc_id            = aws_vpc.test.id
  availability_zone = var.region[count.index]
  cidr_block        = var.cidr_public_subnet_block[count.index]

  tags = {
    Name        = "${var.env}-public-subnet-${count.index + 1}"
    description = var.description
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.cidr_private_subnet_block) > 0 ? length(var.cidr_private_subnet_block) : 0
  vpc_id            = aws_vpc.test.id
  availability_zone = var.region[count.index]
  cidr_block        = var.cidr_private_subnet_block[count.index]

  tags = {
    Name        = "${var.env}-private-subnet-${count.index + 1}"
    description = var.description
  }
}

resource "aws_subnet" "tgw_private_subnet" {
  count             = length(var.cidr_transit_gw_subnet_block) > 0 ? length(var.cidr_transit_gw_subnet_block) : 0
  vpc_id            = aws_vpc.test.id
  availability_zone = var.region[count.index]
  cidr_block        = var.cidr_transit_gw_subnet_block[count.index]

  tags = {
    Name        = "${var.env}-transit-gw-subnet-${count.index + 1}"
    description = var.description
  }
}

resource "aws_subnet" "private_data_store" {
  count             = length(var.cidr_private_subnet_data_store_block) > 0 ? length(var.cidr_private_subnet_data_store_block) : 0
  vpc_id            = aws_vpc.test.id
  availability_zone = var.region[count.index]
  cidr_block        = var.cidr_private_subnet_data_store_block[count.index]

  tags = {
    Name        = "${var.env}-private-data-store-subnet-${count.index + 1}"
    description = var.description
  }
}

# Conditionally create the public route table if public subnets exist
resource "aws_route_table" "public_route_table" {
  count = length(var.cidr_public_subnet_block) > 0 ? 1 : 0
  vpc_id = aws_vpc.test.id

  tags = {
    Name        = "${var.env}-public-route-table"
    description = var.description
  }
}

# Conditionally create the private route table if private subnets exist
resource "aws_route_table" "private_route_table" {
  count = length(var.cidr_private_subnet_block) > 0 ? 1 : 0
  vpc_id = aws_vpc.test.id

  tags = {
    Name        = "${var.env}-private-route-table"
    description = var.description
  }
}

# Conditionally create the tgw private route table if tgw subnets exist
resource "aws_route_table" "tgw_private_route_table" {
  count = length(var.cidr_transit_gw_subnet_block) > 0 ? 1 : 0
  vpc_id = aws_vpc.test.id

  tags = {
    Name        = "${var.env}-TGW-private-route-table"
    description = var.description
  }
}

# Conditionally create the private data store route table if private data store subnets exist
resource "aws_route_table" "private_data_store_route_table" {
  count = length(var.cidr_private_subnet_data_store_block) > 0 ? 1 : 0
  vpc_id = aws_vpc.test.id

  tags = {
    Name        = "${var.env}-private-data-store-route-table"
    description = var.description
  }
}

# Conditionally create the Internet Gateway if public subnets exist
resource "aws_internet_gateway" "igw" {
  count = length(var.cidr_public_subnet_block) > 0 ? 1 : 0
  vpc_id = aws_vpc.test.id

  tags = {
    Name        = "${var.env}-igw"
    description = var.description
  }
}

resource "aws_eip" "nat" {
  count = length(var.cidr_public_subnet_block) > 0 ? 1 : 0

  tags = {
    Name        = "${var.env}-nat-eip"
    description = var.description
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.cidr_public_subnet_block) > 0 ? 1 : 0
  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name        = "${var.env}-nat-gateway"
    description = var.description
  }

  depends_on = [aws_internet_gateway.igw]
}

# Conditionally create public route table association if public subnets exist
resource "aws_route_table_association" "public_route_table" {
  count         = length(var.cidr_public_subnet_block) > 0 ? length(var.cidr_public_subnet_block) : 0
  subnet_id     = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table[0].id
}

# Conditionally create private route table association if private subnets exist
resource "aws_route_table_association" "private_route_table" {
  count         = length(var.cidr_private_subnet_block) > 0 ? length(var.cidr_private_subnet_block) : 0
  subnet_id     = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table[0].id
}

# Conditionally create tgw private route table association if tgw subnets exist
resource "aws_route_table_association" "tgw_private_route_table" {
  count         = length(var.cidr_transit_gw_subnet_block) > 0 ? length(var.cidr_transit_gw_subnet_block) : 0
  subnet_id     = aws_subnet.tgw_private_subnet[count.index].id
  route_table_id = aws_route_table.tgw_private_route_table[0].id
}

# Conditionally create private data store route table association if private data store subnets exist
resource "aws_route_table_association" "private_data_store_route_table" {
  count         = length(var.cidr_private_subnet_data_store_block) > 0 ? length(var.cidr_private_subnet_data_store_block) : 0
  subnet_id     = aws_subnet.private_data_store[count.index].id
  route_table_id = aws_route_table.private_data_store_route_table[0].id
}

# Conditionally create a route to the Internet Gateway if public route table exists
resource "aws_route" "igw_route" {
  count = length(var.cidr_public_subnet_block) > 0 ? 1 : 0
  route_table_id         = aws_route_table.public_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route" "private_nat_route" {
  count = length(var.cidr_private_subnet_block) > 0 ? 1 : 0
  route_table_id         = aws_route_table.private_route_table[0].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}
