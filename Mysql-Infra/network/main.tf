########################################
#               network moduble (vpc)
######################################

##use default vpc
data "aws_vpc" "default" {
  default = true
}

#create vpc
resource "aws_vpc" "mysql" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = var.vpc_name
  }
}

#pub subnet
resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.mysql.id
  cidr_block        = var.pub_sub_cidr
  availability_zone = var.az01

  tags = {
    Name = var.pub_sub_name
  }
}

#pvt subnet1
resource "aws_subnet" "pvt-subnet1" {
  vpc_id            = aws_vpc.mysql.id
  cidr_block        = var.pvt_sub1_cidr
  availability_zone = var.az01

  tags = {
    Name = var.pvt_sub_name1
  }
}
#pvt subnet2
resource "aws_subnet" "pvt-subnet2" {
  vpc_id            = aws_vpc.mysql.id
  cidr_block        = var.pvt_sub2_cidr
  availability_zone = var.az02

  tags = {
    Name = var.pvt_sub_name2
  }
}
#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.mysql.id

  tags = {
    Name = var.igw_name
  }
}

#elastic ip
resource "aws_eip" "NAT_eip" {
  depends_on = [aws_internet_gateway.igw]
}

#nat gateway
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id     = aws_subnet.public-subnet.id

  tags = {
    Name = var.NAT_name
  }

  depends_on = [aws_internet_gateway.igw]
}

#####route table public
resource "aws_route_table" "pubRT" {
  vpc_id = aws_vpc.mysql.id

  route {
    cidr_block = var.RT-cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
  route {
    cidr_block = var.vpc_cidr
    gateway_id = var.local_gateway
  }
  route {
    cidr_block                = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.mysql-vpc-peering.id
  }

  tags = {
    Name = var.public_RT_name
  }
  depends_on = [aws_vpc_peering_connection.mysql-vpc-peering]
}


#####route table pvt
resource "aws_route_table" "pvt" {
  vpc_id = aws_vpc.mysql.id

  route {
    cidr_block = var.RT-cidr_block
    gateway_id = aws_nat_gateway.gw.id
  }
  route {
    cidr_block = var.vpc_cidr
    gateway_id = var.local_gateway
  }
  route {
    cidr_block                = data.aws_vpc.default.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.mysql-vpc-peering.id
  }

  tags = {
    Name = var.private_RT_name
  }
  depends_on = [aws_vpc_peering_connection.mysql-vpc-peering]
}

#public subnet association
resource "aws_route_table_association" "pub" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.pubRT.id
}
#pvt subnet association
resource "aws_route_table_association" "pvt-subnet1" {
  subnet_id      = aws_subnet.pvt-subnet1.id
  route_table_id = aws_route_table.pvt.id
}
resource "aws_route_table_association" "pvt-subnet2" {
  subnet_id      = aws_subnet.pvt-subnet2.id
  route_table_id = aws_route_table.pvt.id
}


#vpc peering
resource "aws_vpc_peering_connection" "mysql-vpc-peering" {
  peer_vpc_id = aws_vpc.mysql.id ##our vpc id
  vpc_id      = data.aws_vpc.default.id
  auto_accept = var.vpc_accept
}

resource "aws_route" "default_vpc_to_peer" {
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = aws_vpc.mysql.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.mysql-vpc-peering.id
  depends_on                = [aws_vpc_peering_connection.mysql-vpc-peering]
}
