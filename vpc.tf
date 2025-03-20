resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name      = local.vpc_name
    yor_trace = "b1919cdd-f59f-4ef8-83c8-58dc837a447b"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = "${aws_vpc.my_vpc.id}"
  cidr_block              = "10.0.4.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = "true"

  tags = {
    Name      = local.public_subnet_name
    yor_trace = "d96ee800-b31b-49e9-9df6-d787ca3f2bde"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.my_vpc.id}"
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name      = local.private_subnet_name
    yor_trace = "7a32f75f-43c7-4b1c-81bc-dddfec3b18d2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.my_vpc.id

  tags = {
    Name      = local.igw_name
    yor_trace = "84b4b9f1-3638-4144-9607-beeae272fb6d"
  }
}

resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name      = local.rt_name
    yor_trace = "2ba8d03e-e7c9-49e5-80fc-f6ed41a78714"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.second_rt.id
}