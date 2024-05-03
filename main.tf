resource "aws_vpc" "minha_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_1a" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_public_1a
  }

}

# Correcao primeira issue
resource "aws_flow_log" "example" {
  log_destination      = "arn:aws:s3:::daniel-clc11-tfstate"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.minha_vpc.id
}

# Correcao segunda issue
resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.minha_vpc.id
  
  tags = {
    Name = "my-iac-sg"
  }
}



resource "aws_subnet" "public_1c" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.20.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = var.subnet_public_1c
  }

}

resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.100.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_private_1a
  }

}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.minha_vpc.id
  cidr_block        = "10.0.200.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = var.subnet_private_1c
  }

}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.minha_vpc.id

  tags = {
    Name = "igw-vpc-iac-clc11"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.minha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "iac_public_rt"
  }
}

resource "aws_route_table_association" "rt_public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "rt_public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_eip" "ip_nat_1a" {
  domain           = "vpc"
}

resource "aws_nat_gateway" "natgateway_1a" {
  allocation_id = aws_eip.ip_nat_1a.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name = "iac-natgatway-1a"
  }
}

resource "aws_eip" "ip_nat_1c" {
  domain           = "vpc"
}

resource "aws_nat_gateway" "natgateway_1c" {
  allocation_id = aws_eip.ip_nat_1c.id
  subnet_id     = aws_subnet.public_1c.id

  tags = {
    Name = "iac-natgatway-1c"
  }
}

resource "aws_route_table" "private_rt_1a" {
  vpc_id = aws_vpc.minha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1a.id
  }

  tags = {
    Name = "iac-private-rt-1a"
  }
}

resource "aws_route_table" "private_rt_1c" {
  vpc_id = aws_vpc.minha_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgateway_1c.id
  }

  tags = {
    Name = "iac-private-rt-1c"
  }
}


resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private_rt_1a.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private_rt_1c.id
}