resource "aws_ec2_transit_gateway" "tgw" {

  description = "Transit Gateway to manage traffic between private and public subnets"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"
  
  tags = {
    Name = "${var.environment}-tgw"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_ec2_transit_gateway_route_table" "tgw-rt" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "${var.environment}-tgw-rt"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-va-01" {
  vpc_id = aws_vpc.vpc-01.id
  subnet_ids = [aws_subnet.subnet-01.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

    tags = {
    Name = "${var.environment}-tgw-va-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

# Associate the route table to attachment
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-ass-01" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-va-01.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-va-02" {
  vpc_id = aws_vpc.vpc-02.id
  subnet_ids = [aws_subnet.subnet-02.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

    tags = {
    Name = "${var.environment}-tgw-va-02"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

# Associate the route table to attachment
resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-ass-02" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-va-02.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
}


resource "aws_ec2_transit_gateway_vpc_attachment" "tgw-va-03" {
  vpc_id = aws_vpc.vpc-03.id
  subnet_ids = [aws_subnet.subnet-03.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

    tags = {
    Name = "${var.environment}-tgw-va-03"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw-rt-ass-03" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw-va-03.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
}



resource "aws_ec2_transit_gateway_route" "tgw-route-subnet-01" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
  destination_cidr_block          = var.subnet1_cidr_block 
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.tgw-va-01.id
}


resource "aws_ec2_transit_gateway_route" "tgw-route-subnet-02" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
  destination_cidr_block          = var.subnet2_cidr_block 
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.tgw-va-02.id
}


resource "aws_ec2_transit_gateway_route" "tgw-route-subnet-03" {
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.tgw-rt.id
  destination_cidr_block          = var.subnet3_cidr_block
  transit_gateway_attachment_id   = aws_ec2_transit_gateway_vpc_attachment.tgw-va-03.id
}



