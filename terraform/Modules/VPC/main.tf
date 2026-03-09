resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "Main"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-west-2b"

    tags = {
        Name = "Public Subnet 2"
    }
}

resource "aws_subnet" "private_1" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "Private Subnet 1"
  }
}

resource "aws_subnet" "private_2" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name = "Private Subnet 2"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "ecs-igw"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  
  tags = {
    Name = "Public-rt"  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.0.0/16"
    gateway_id = "local"
  }
  
  tags = {
    Name = "Private-rt"
  }
  
}

resource "aws_route_table_association" "public_1" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-2.s3"
  vpc_endpoint_type = "Gateway"
}
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-2.dynamodb"
  vpc_endpoint_type = "Gateway"
}
resource "aws_vpc_endpoint" "cloudwatch" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-2.logs"
  private_dns_enabled = true
  vpc_endpoint_type = "Interface"
}
resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-2.ecr.api"
  private_dns_enabled = true
  vpc_endpoint_type = "Interface"
  
}
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.eu-west-2.ecr.dkr"
  private_dns_enabled = true
  vpc_endpoint_type = "Interface"
  
}

resource "aws_vpc_endpoint_route_table_association" "s3" {
  route_table_id  = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
  route_table_id  = aws_route_table.private.id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb.id
}

resource "aws_vpc_endpoint_security_group_association" "ecr-api" {
  security_group_id = var.ecr_sg
  vpc_endpoint_id   = aws_vpc_endpoint.ecr-api.id
  
}
resource "aws_vpc_endpoint_security_group_association" "ecr-dkr" {
  security_group_id = var.ecr_sg
  vpc_endpoint_id   = aws_vpc_endpoint.ecr_dkr.id
  
}
resource "aws_vpc_endpoint_security_group_association" "cloudwatch" {
  security_group_id = var.cloudwatch_sg
  vpc_endpoint_id   = aws_vpc_endpoint.cloudwatch.id
  
}