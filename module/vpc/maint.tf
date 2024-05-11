resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Project VPC"
 }
}

resource "aws_subnet" "public_subnets" {
 count      = length(var.public_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.public_subnet_cidrs, count.index)
 
 tags = {
   Name = "Public Subnet ${count.index + 1}"
 }
}
 
resource "aws_subnet" "private_subnets" {
 count      = length(var.private_subnet_cidrs)
 vpc_id     = aws_vpc.main.id
 cidr_block = element(var.private_subnet_cidrs, count.index)
 
 tags = {
   Name = "Private Subnet ${count.index + 1}"
 }
}

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Project VPC IG"
 }
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
  subnet_id      = "${element(aws_subnet.public.*.id,count.index)}"
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = "${element(aws_subnet.private.*.id,count.index)}" 
  route_table_id = aws_route_table.private[count.index].id
}

# add

resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-template-"
  image_id      = "ami-0900fe555666598a2"
  instance_type = "t2.micro"

  # Define user data script to set up WordPress and pass credentials as environment variables
  user_data = <<-EOF
              #!/bin/bash
              export DB_USER=your_db_pauldchang
              export DB_PASSWORD=your_db_password
              export DB_HOST=your_db_host
              export DB_NAME=your_db_name
              # Install and configure WordPress here
              EOF
}

  # Create an Auto Scaling Group (ASG) using the launch template


resource "aws_autscaling_group" "wordpress_asg"  {
  launch_template  {
    id = aws_launch_template.my_launch_template.id
    version = "$Lastest"
    min_size = 1
    max_size = 99
    desired_capacity = 1
    vpc_zone_identifier = aws_subnet.public_subnets[*].id
    termination_policies = ["Default"]
  }
}
