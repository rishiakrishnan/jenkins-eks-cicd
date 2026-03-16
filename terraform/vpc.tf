# VPC
resource "aws_vpc" "vpc-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "terro-vpc-1"
    managed_by = "${var.managed-by}"
  }
}
# INTERNET GATEWAY
resource "aws_internet_gateway" "i-gw-1" {
  vpc_id = aws_vpc.vpc-1.id

  tags = {
    Name = "terro-igw-1"
    managed_by = "${var.managed-by}"
  }
}

resource "aws_eip" "nat-gw-1-eip" {
  domain   = "vpc"
    tags = {
        Name = "nat-gw-1-eip"
        managed_by = "${var.managed-by}"
    }
}


# NAT GATEWAY 1
resource "aws_nat_gateway" "nat-gw-1" {
  subnet_id     = aws_subnet.pub-sub-1.id
  allocation_id = aws_eip.nat-gw-1-eip.id
  
  tags = {
    Name = "nat gateway-1"
    managed_by = "${var.managed-by}"
  }
  depends_on = [aws_internet_gateway.i-gw-1]
}


# PUBLIC SUBNET 1 [ATTACH INTERNET GATWAY]
resource "aws_subnet" "pub-sub-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub-1"
    managed_by = "${var.managed-by}"
  }
}

# PRIVATE SUBNET 1
resource "aws_subnet" "priv-sub-1" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "priv-sub-1"
    managed_by = "${var.managed-by}"
  }
}

# PUBLIC SUBNET 2 [ATTACH INTERNET GATWAY]
resource "aws_subnet" "pub-sub-2" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "pub-sub-2"
    managed_by = "${var.managed-by}"
  }
}

# PRIVATE SUBNET 2
resource "aws_subnet" "priv-sub-2" {
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "priv-sub-2"
    managed_by = "${var.managed-by}"
  }
}


# PUBLIC ROUTE 1
resource "aws_route_table" "pub-rt-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.i-gw-1.id
  }

  tags = {
    Name = "pub-rt-1"
    managed_by = "${var.managed-by}"
  }
}

# PRIVATE ROUTE 1
resource "aws_route_table" "priv-rt-1" {
  vpc_id = aws_vpc.vpc-1.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw-1.id
  }
  
  tags = {
    Name = "priv-rt-1"
    managed_by = "${var.managed-by}"
  }
}

# PUBLIC SUBNET 1 ASSOCIATION
resource "aws_route_table_association" "pub-sub-with-rt-1" {
  subnet_id      = aws_subnet.pub-sub-1.id
  route_table_id = aws_route_table.pub-rt-1.id
}

# PRIVATE SUBNET 1 ASSOCIATION
resource "aws_route_table_association" "priv-sub-with-rt-1" {
  subnet_id      = aws_subnet.priv-sub-1.id
  route_table_id = aws_route_table.priv-rt-1.id
}

# PUBLIC SUBNET 2 ASSOCIATION
resource "aws_route_table_association" "pub-sub-with-rt-2" {
  subnet_id      = aws_subnet.pub-sub-2.id
  route_table_id = aws_route_table.pub-rt-1.id
}

# PRIVATE SUBNET 2 ASSOCIATION
resource "aws_route_table_association" "priv-sub-with-rt-2" {
  subnet_id      = aws_subnet.priv-sub-2.id
  route_table_id = aws_route_table.priv-rt-1.id
}

# SECURITY GROUP 1 [ PUBLIC ACCESS]
resource "aws_security_group" "sec-grp-1" {
  name        = "secure-group-1"
  description = "Allow traffic from anywhere"
  vpc_id      = aws_vpc.vpc-1.id
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["192.168.29.249/32",aws_vpc.vpc-1.cidr_block]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
    ingress {
    from_port        = 30080
    to_port          = 30080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = {
    Name = "secure-group-1"
    managed_by = "${var.managed-by}"
  }

}