resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.vpc_tags
}

## Public networking

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags   = var.vpc_tags
}

resource "aws_eip" "public_elastic_ip" {
  vpc        = true
  depends_on = [aws_internet_gateway.internet_gateway]
}

#NAT public subnet --> Internet Gateway
resource "aws_nat_gateway" "internet_nat" {
  allocation_id = aws_eip.public_elastic_ip.id
  subnet_id     = element(aws_subnet.subnet_public.*.id, 0) # nat on second subnet 
  depends_on    = [aws_internet_gateway.internet_gateway]
  tags          = var.vpc_tags
}

resource "aws_subnet" "subnet_public" {
  vpc_id                  = aws_vpc.main.id
  count                   = length(var.subnet_public_cidr_block)
  cidr_block              = element(var.subnet_public_cidr_block, count.index)
  availability_zone       = element(var.subnet_availability_zone, count.index)
  tags                    = var.vpc_tags
  map_public_ip_on_launch = var.subnet_public_map_public_ip
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main.id
  tags   = var.vpc_tags # TODO: add a specific routing tag
}

resource "aws_route" "route_public_internet_gateway" {
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = var.route_internet_gateway_destination_cidr
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_private_cidr_block)
  subnet_id      = element(aws_subnet.subnet_public.*.id, count.index)
  route_table_id = aws_route_table.route_table_public.id
}

## Private networking
resource "aws_subnet" "subnet_private" {
  vpc_id            = aws_vpc.main.id
  count             = length(var.subnet_private_cidr_block)
  cidr_block        = element(var.subnet_private_cidr_block, count.index)
  availability_zone = element(var.subnet_availability_zone, count.index)
  tags              = var.vpc_tags
}

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.main.id
  tags   = var.vpc_tags # TODO: add a specific routing tag
}

### Routing outgoing traffic from private subnet to internet
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.route_table_private.id
  destination_cidr_block = var.route_internet_gateway_destination_cidr
  nat_gateway_id         = aws_nat_gateway.internet_nat.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.subnet_private_cidr_block)
  subnet_id      = element(aws_subnet.subnet_private.*.id, count.index)
  route_table_id = aws_route_table.route_table_private.id
}

## VPC default Security Group

resource "aws_security_group" "default_vpc_segurity_group" {
  name        = var.default_vpc_segurity_group_name
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.main.id
  depends_on  = [aws_vpc.main]
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = true
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.vpc_tags
}

## EC2 security group for loadbalancer

resource "aws_security_group" "allow_8080_segurity_group" {
  name        = "backend-dev-sg"
  description = "8080 security group to allow inbound from 0.0.0.0"
  vpc_id      = aws_vpc.main.id
  depends_on  = [aws_vpc.main]
  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.vpc_tags
}

# resource "aws_network_interface_sg_attachment" "sg_attachment" {
#   security_group_id    = aws_security_group.allow_8080_segurity_group.id
#   network_interface_id = var.instance_network_interface_id
# }


## Redis SG

resource "aws_security_group" "redis_vpc_segurity_group" {
  name        = var.redis_vpc_segurity_group_name
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.main.id
  depends_on  = [aws_vpc.main]
  ingress {
    from_port   = "6379"
    to_port     = "6379"
    protocol    = "tcp"
    self        = true
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    self        = "true"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.vpc_tags
}