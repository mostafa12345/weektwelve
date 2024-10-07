resource "aws_vpc" "vpc-02" {
  cidr_block    = var.vpc2_cidr_block

  tags = {
    Name = "${var.environment}-vpc-02"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_subnet" "subnet-02" {
  vpc_id     = aws_vpc.vpc-02.id
  cidr_block = var.subnet2_cidr_block

  tags = {
    Name = "${var.environment}-subnet-02"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}

resource "aws_route_table" "rt-02" {
  vpc_id = aws_vpc.vpc-02.id

  route {
    cidr_block = "0.0.0.0/0"
    transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  }

  tags = {
    Name = "${var.environment}-rt-02"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}


resource "aws_route_table_association" "rtas-02" {
  subnet_id = aws_subnet.subnet-02.id
  route_table_id = aws_route_table.rt-02.id
}


resource "aws_security_group" "sg-02" {
  name  = "sg2"
  vpc_id = aws_vpc.vpc-02.id

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
    Name = "${var.environment}-sg-02"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}


resource "aws_instance" "ec2-02" {
  ami   = "ami-0a3c3a20c09d6f377"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet-02.id
  vpc_security_group_ids = [aws_security_group.sg-02.id]
  key_name = aws_key_pair.kp-01.key_name

 tags = {
    Name = "${var.environment}-ec2-02"
    Environment = "${var.environment}"
    Owner = "${var.owner}"
  }
}
