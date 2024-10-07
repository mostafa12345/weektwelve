resource "aws_vpc" "vpc-03" {
  cidr_block    = var.vpc3_cidr_block

  tags = {
    Name = "${var.environment}-vpc-03"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "subnet-03" {
  vpc_id     = aws_vpc.vpc-03.id
  cidr_block = var.subnet3_cidr_block

  tags = {
    Name = "${var.environment}-subnet-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-03.id

  tags = {
    Name = "${var.environment}-subnet-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table" "rt-03" {
  vpc_id = aws_vpc.vpc-03.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    cidr_block = var.vpc2_cidr_block
    transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  }

 route {
    cidr_block = var.vpc1_cidr_block
    transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "${var.environment}-rt-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}


resource "aws_route_table_association" "rtas-03" {
  subnet_id = aws_subnet.subnet-03.id
  route_table_id = aws_route_table.rt-03.id
}




