# get availability zone
data "aws_availability_zones" "available" {
  state = "available"
}

# Create a VPC for the region associated with the AZ
resource "aws_vpc" "VPC-EyeEM" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
  tags = {
    Name = var.environment
  }
}


# Creaet three public Subnets
resource "aws_subnet" "public_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.VPC-EyeEM.id
  cidr_block              = "10.0.${10 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "PublicSubnet-${count.index}-EyeEM"
  }
}

# Creaet three private Subnets
resource "aws_subnet" "private_subnet" {
  count                   = length(data.aws_availability_zones.available.names)
  vpc_id                  = aws_vpc.VPC-EyeEM.id
  cidr_block              = "10.0.${20 + count.index}.0/24"
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = false # to have a private IP add
  tags = {
    Name = "PrivateSubnet-${count.index}-EyeEM"
  }
}

# internet gateway
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.VPC-EyeEM.id

  tags = {
    "Name" = var.environment
  }
}

# Route table
resource "aws_route_table" "mainRoute" {
  vpc_id = aws_vpc.VPC-EyeEM.id
  route = [{
    carrier_gateway_id         = ""
    cidr_block                 = "0.0.0.0/0"
    destination_prefix_list_id = ""
    egress_only_gateway_id     = ""
    gateway_id                 = aws_internet_gateway.main-igw.id
    instance_id                = ""
    ipv6_cidr_block            = ""
    local_gateway_id           = ""
    nat_gateway_id             = ""
    network_interface_id       = ""
    transit_gateway_id         = ""
    vpc_endpoint_id            = ""
    vpc_peering_connection_id  = ""
  }]
  tags = {
    Name = var.environment
  }
}


# Route table associate
resource "aws_route_table_association" "main-Route-Associat" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.mainRoute.id
}

#Security Group for levelupvpc
resource "aws_security_group" "allow-HTTPS-sg" {
  vpc_id      = aws_vpc.VPC-EyeEM.id
  name        = "allow-HTTPS-sg"
  description = "security group that allows HTTPS"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443 # Allow HTTPS
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.environment
  }
}


