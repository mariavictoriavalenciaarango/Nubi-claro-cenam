data "aws_caller_identity" "current" {}

## Obtener las AZs disponibles en la región
data "aws_availability_zones" "available" {
  state = "available"
}

## Limitar las AZs según la cantidad solicitada
locals {
  selected_azs = slice(data.aws_availability_zones.available.names, 0, var.availability_zones_to_use)
  unique_id = substr(md5("${var.Region}-${var.Environment}-${data.aws_caller_identity.current.account_id}"), 0, 8)
}

## VPC
resource "aws_vpc" "main_vpc" {
  cidr_block                       = var.vpc_cidr
  assign_generated_ipv6_cidr_block = var.ipv6_support
  enable_dns_support               = true
  enable_dns_hostnames             = true
  tags = {
    Name = "${var.vpc_name}-${var.Project}-${local.unique_id}"
  }
}

## Subnets Públicas
resource "aws_subnet" "public_subnets" {
  count                   = length(local.selected_azs)
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  ipv6_cidr_block         = var.ipv6_support ? cidrsubnet(aws_vpc.main_vpc.ipv6_cidr_block, 8, count.index) : null
  availability_zone       = element(local.selected_azs, count.index)
  map_public_ip_on_launch = true
  
  tags = {
    Name = "public-subnet-${var.Project}-${local.unique_id}-${count.index + 1}"
  }
}

## Subnets Privadas
resource "aws_subnet" "private_subnets" {
  count             = length(local.selected_azs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(local.selected_azs))
  ipv6_cidr_block   = var.ipv6_support ? cidrsubnet(aws_vpc.main_vpc.ipv6_cidr_block, 8, count.index + length(local.selected_azs)) : null
  availability_zone = element(local.selected_azs, count.index)
  
  tags = {
    Name = "private-subnet-${var.Project}-${local.unique_id}-${count.index + 1}"
  }
}

## Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags   = {
    Name = "igw-${var.Project}-${local.unique_id}"
  }
}

# NAT Gateways para las subnets privadas
resource "aws_nat_gateway" "nat_gateway" {
  count         = var.enable_nat_gateway ? length(local.selected_azs) : 0
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags = {
    Name = "nat-gateway-${var.Project}-${local.unique_id}-${count.index + 1}"
  }
}

## Tabla de Enrutamiento para Subnets Públicas
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table-${var.Project}-${local.unique_id}"
  }
}

## Asociacion de Tabla de Enrutamiento Pública con Subnets Públicas
resource "aws_route_table_association" "public_subnet_associations" {
  count          = length(local.selected_azs)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

## NAT Gateway y Elastic IP si está habilitado
resource "aws_eip" "nat_eip" {
  count    = var.enable_nat_gateway ? length(local.selected_azs) : 0
  domain   = "vpc"
}

# Tabla de Enrutamiento para Subnets Privadas
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat_gateway[*].id, 0)
  }

  tags = {
    Name = "private-route-table-${var.Project}-${local.unique_id}"
  }
}

# Asociacion de Tabla de Enrutamiento Privada con Subnets Privadas
resource "aws_route_table_association" "private_subnet_associations" {
  count          = length(local.selected_azs)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

# Grupo de Seguridad para Subnets Públicas
resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.main_vpc.id
  description = "Allow inbound HTTP/HTTPS and SSH traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5439
    to_port     = 5439
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public-sg-${var.Project}-${local.unique_id}"
  }
}

# Grupo de Seguridad para Subnets Privadas
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main_vpc.id
  description = "Allow all outbound traffic for private subnets"
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-sg-${var.Project}-${local.unique_id}"
  }
}

# Reglas ACLs

# ACL para Subnets Públicas
resource "aws_network_acl" "public_acl" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "public-acl-${var.Project}-${local.unique_id}"
  }
}

resource "aws_network_acl_rule" "public_inbound" {
  network_acl_id = aws_network_acl.public_acl.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
  egress         = false
}

resource "aws_network_acl_rule" "public_outbound" {
  network_acl_id = aws_network_acl.public_acl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
  egress         = true
}

# ACL para Subnets Privadas usando count
resource "aws_network_acl" "private_acl" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "private-acl-${var.Project}-${local.unique_id}"
  }
}

resource "aws_network_acl_rule" "private_inbound" {
  network_acl_id = aws_network_acl.private_acl.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr
  from_port      = 0
  to_port        = 65535
  egress         = false
}

resource "aws_network_acl_rule" "private_outbound" {
  network_acl_id = aws_network_acl.private_acl.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
  egress         = true
}