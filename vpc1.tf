resource "aws_vpc" "vpc-01" {
  cidr_block    = var.vpc1_cidr_block

  tags = {
    Name = "${var.environment}-vpc-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "subnet-01" {
  vpc_id     = aws_vpc.vpc-01.id
  cidr_block = var.subnet1_cidr_block

  tags = {
    Name = "${var.environment}-subnet-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table" "rt-01" {
  vpc_id = aws_vpc.vpc-01.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "${var.environment}-rt-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}


resource "aws_route_table_association" "rtas-01" {
  subnet_id = aws_subnet.subnet-01.id
  route_table_id = aws_route_table.rt-01.id
}


resource "aws_key_pair" "kp-01" {
  key_name  = "ec2-key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_security_group" "sg-01" {
  name  = "sg1"
  vpc_id = aws_vpc.vpc-01.id

  ingress {
    from_port    = 22
    to_port      = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


egress { 
    from_port    = 0
    to_port      = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 tags = {
    Name = "${var.environment}-sg-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}


resource "aws_instance" "ec2-01" {
  ami   = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet-01.id
  vpc_security_group_ids = [aws_security_group.sg-01.id]
  key_name = aws_key_pair.kp-01.key_name

 tags = {
    Name = "${var.environment}-ec2-01"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}
