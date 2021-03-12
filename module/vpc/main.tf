data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "test-vpc" {
    cidr_block           = var.vpc_cidr_block
    enable_classiclink   = "false"
    instance_tenancy     = "default"    
    tags = {
        Name             = "${var.vpc_tags}-vpc"
    }
}

resource "aws_subnet" "test-subnet-public" {
    count                   = "${length(var.subnet_cidrs_public)}"
    map_public_ip_on_launch = "true"
    vpc_id                  = "${aws_vpc.test-vpc.id}"
    cidr_block              = "${var.subnet_cidrs_public[count.index]}"
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    tags = {
            Name            = "${var.vpc_tags}-${count.index}-subnet" 
    }
}


resource "aws_internet_gateway" "test-igw" {
    vpc_id   = "${aws_vpc.test-vpc.id}"
    tags = {
        Name = "${var.vpc_tags}-igw"
    }
}

resource "aws_route_table" "test-public-crt" {
    vpc_id = "${aws_vpc.test-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.test-igw.id}" 
    }
    
    tags = {
        Name       = "${var.vpc_tags}-crt"
    }
}

resource "aws_route_table_association" "test-crta-public-subnet-1"{
    count           = "${length(aws_subnet.test-subnet-public)}"
    subnet_id       = "${element(aws_subnet.test-subnet-public.*.id, count.index)}"
    route_table_id  = "${aws_route_table.test-public-crt.id}"
}