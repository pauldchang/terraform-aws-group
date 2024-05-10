resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public" {
  count                  = 3
  vpc_id                 = aws_vpc.main.id
  cidr_block             = "10.0.${count.index}.0/24"
 
}

resource "aws_subnet" "private" {
  count                  = 3
  vpc_id                 = aws_vpc.main.id
  cidr_block             = "10.0.${count.index + 3}.0/24"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "nat" {
  count             = 3
  subnet_id         = aws_subnet.private[count.index].id
  allocation_id     = aws_eip.nat[count.index].id
}

resource "aws_eip" "nat" {
  count = 3
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}



resource "aws_route_table" "private" {
   count = 3
  vpc_id = aws_vpc.main.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }

}

resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = "${element(aws_subnet.public..id, count.index)}"
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = "${element(aws_subnet.private..id, count.index)}" 
  route_table_id = aws_route_table.private[count.index].id