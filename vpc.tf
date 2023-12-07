resource "aws_vpc" "my_vpc" {
    cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_hostnames = true

    tags = {
        Name = local.vpc_name
    }
}

resource "aws_subnet" "public" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    cidr_block = "10.0.4.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = "true"
 
    tags = {
        Name = local.public_subnet_name
    } 
}

resource "aws_subnet" "private" {
    vpc_id = "${aws_vpc.my_vpc.id}"
    cidr_block = "10.0.1.0/24"
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
        Name = local.private_subnet_name
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = local.igw_name
    }
}

resource "aws_route_table" "second_rt" {
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    
    tags = {
        Name = local.rt_name
    }
}

resource "aws_route_table_association" "public_subnet_asso" {
    subnet_id       = aws_subnet.public.id
    route_table_id  = aws_route_table.second_rt.id
}