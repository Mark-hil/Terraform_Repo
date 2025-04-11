#####################################
# VPC Configuration
#####################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.env_prefix}-vpc"
    }
  )
}

#####################################
# Internet Gateway
#####################################
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.env_prefix}-igw"
    }
  )
}

#####################################
# Public Subnets
#####################################
resource "aws_subnet" "public" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone = var.availability_zones[count.index]

  # Required for EKS
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name                                            = "${var.env_prefix}-public-${count.index + 1}"
      "kubernetes.io/role/elb"                        = "1"
      "kubernetes.io/cluster/${var.env_prefix}-cluster" = "shared"
    }
  )
}

#####################################
# Routing Configuration
#####################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env_prefix}-public-rt"
    }
  )
}

resource "aws_route_table_association" "public" {
  count          = length(var.availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#####################################
# Security Groups
#####################################
resource "aws_security_group" "default" {
  name        = "${var.env_prefix}-default-sg"
  description = "Default security group for ${var.env_prefix} VPC"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.allowed_cidr_blocks
    description = "Allow all inbound traffic from allowed CIDR blocks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.env_prefix}-default-sg"
    }
  )
}