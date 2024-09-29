

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = merge(
    var.common_tags,
     var.vpc_tags,
     {
        Name = local.name
     }
     )

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
     var.igw_tags,
     {
        Name = local.name
     }
     )
}



resource "aws_subnet" "public" {
  count = length(var.public_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    var.public_subnets_tags,
    {
      Name = "${local.name}-public-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    var.private_subnets_tags,
    {
      Name = "${local.name}-private-${local.az_names[count.index]}"
    }
  )
}

resource "aws_subnet" "db" {
  count = length(var.db_subnets_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.db_subnets_cidr[count.index]
  availability_zone = local.az_names[count.index]
  tags = merge(
    var.common_tags,
    var.db_subnets_tags,
    {
      Name = "${local.name}-db-${local.az_names[count.index]}"
    }
  )
}


resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = "${local.name}-eip"
  }
}

resource "aws_nat_gateway" "main"{
  allocation_id = aws_eip.eip.id
  subnet_id = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
     var.nat_gw_tags,
     {
        Name = local.name
     }
  )
     depends_on = [aws_internet_gateway.gw] #Explicit dependency is added to ensure
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
     var.public_rt_tags,
     {
        Name = "${local.name}-public"
     }
  )
  
}


resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
     var.private_rt_tags,
     {
        Name = "${local.name}-private"
     }
  )
  
}

resource "aws_route_table" "db" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
     var.db_rt_tags,
     {
        Name = "${local.name}-db"
     }
  )
  
}


resource "aws_route" "public_route" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.gw.id
  
}

resource "aws_route" "private_route" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id                = aws_nat_gateway.main.id
}

resource "aws_route" "db_route" {
  route_table_id            = aws_route_table.db.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.main.id
  
}

resource "aws_route_table_association" "public_association" {
  count = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_association" {
  count = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "db_association" {
  count = length(var.db_subnets_cidr)
  subnet_id      = element(aws_subnet.db[*].id, count.index)
  route_table_id = aws_route_table.db.id
}