# nat gw
resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.kube-public-1.id
  depends_on    = [aws_internet_gateway.kube-gw]
}

# VPC setup for NAT
resource "aws_route_table" "kube-private" {
  vpc_id = aws_vpc.kubernetes.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "kube-private-1"
  }
}

# route associations private
resource "aws_route_table_association" "kube-private-1-a" {
  subnet_id      = aws_subnet.kube-private-1.id
  route_table_id = aws_route_table.kube-private.id
}

resource "aws_route_table_association" "kube-private-2-a" {
  subnet_id      = aws_subnet.kube-private-2.id
  route_table_id = aws_route_table.kube-private.id
}
