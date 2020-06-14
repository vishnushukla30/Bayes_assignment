# Internet VPC
resource "aws_vpc" "kubernetes" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"
  tags = {
    Name = "kubernetes"
  }
}

# Subnets

resource "aws_subnet" "kube-public-1" {
  vpc_id     = "${aws_vpc.kubernetes.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1a"

  tags = {
     Name = "kube-public-1"
  }
}
resource "aws_subnet" "kube-public-2" {
  vpc_id     = "${aws_vpc.kubernetes.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "ap-south-1b"

  tags = {
     Name = "kube-public-2"
  }
}

resource "aws_subnet" "kube-private-1" {
  vpc_id     = "${aws_vpc.kubernetes.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "ap-south-1a"

  tags = {
     Name = "kube-private-1"
  }
}

resource "aws_subnet" "kube-private-2" {
  vpc_id     = "${aws_vpc.kubernetes.id}"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "ap-south-1b"

  tags = {
     Name = "kube-private-2"
  }
}

# Internet GW
resource "aws_internet_gateway" "kube-gw" {
   vpc_id = "${aws_vpc.kubernetes.id}"

   tags = {
       Name = "kube-gw"
   }
}

# Route tables
resource "aws_route_table" "kube-public" {
   vpc_id = "${aws_vpc.kubernetes.id}"
   route {
         cidr_block = "0.0.0.0/0"
         gateway_id = "${aws_internet_gateway.kube-gw.id}"
   }
   tags = {
       Name = "kube-public-1"
   }
}

# route association public
resource "aws_route_table_association" "kube-public-1-a" {
  subnet_id = "${aws_subnet.kube-public-1.id}"
  route_table_id = "${aws_route_table.kube-public.id}"
}

resource "aws_route_table_association" "kube-public-2-a" {
  subnet_id = "${aws_subnet.kube-public-2.id}"
  route_table_id = "${aws_route_table.kube-public.id}"
}
