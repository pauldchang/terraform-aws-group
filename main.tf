<<<<<<< HEAD
# # resource "aws_instance" "ec2_instance" {
# #   count         = 3
# #   ami           = "ami-0900fe555666598a2"  # Change this to your desired AMI
# #   instance_type = "t2.micro"  # Change this to your desired instance type
# # }

# # resource "aws_db_instance" "db_instance" {
# #   count           = 2
# #   instance_class  = "db.t2.micro"  # Change this to your desired instance class
# #   engine          = "mysql"  # Change this to your desired database engine
# #   engine_version  = "5.7"  # Change this to your desired database engine version
# #   allocated_storage = 2  # Change this to your desired allocated storage in GB
# # }

# # resource "aws_autoscaling_group" "asg" {
# #   launch_configuration = aws_launch_configuration.ec2_launch_config.name
# #   min_size             = 3  # Minimum number of instances
# #   max_size             = 6  # Maximum number of instances
# #   desired_capacity     = 3  # Desired number of instances
# # }
=======


<<<<<<< HEAD
# # resource "aws_launch_configuration" "ec2_launch_config" {
# #   name_prefix          = "group-"
# #   image_id             = "ami-0900fe555666598a2"  # Change this to your desired AMI
# #   instance_type        = "t2.micro"  # Change this to your desired instance type
# # }
# resource "aws_vpc" "my_vpc" {
#   cidr_block = var.cidr_block
=======

# resource "aws_vpc" "my_vpc" {
#   cidr_block = "10.0.0.0/16"
# }
resource "aws_vpc" "my_vpc" {
  cidr_block       = "192.168.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-2a"  # 

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-2b"  # 

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-2c"  # 

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-2a"  # 

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "us-east-2b"  # 

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "us-east-2c"  # 

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_security_group" "public_sg" {
  vpc_id = aws_vpc.my_vpc.id

  # Define inbound and outbound rules as needed
}

resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.my_vpc.id

#   # Define inbound and outbound rules as needed
>>>>>>> 8bbf10e1cfd3711fc61669b52cf1c5683261c614
# }

# resource "aws_subnet" "public_subnets" {
#   count                = var.num_public_subnets
#   vpc_id               = aws_vpc.my_vpc.id
#   cidr_block           = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index)
#   map_public_ip_on_launch = true
# }

# resource "aws_subnet" "private_subnets" {
#   count                = var.num_private_subnets
#   vpc_id               = aws_vpc.my_vpc.id
#   cidr_block           = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + var.num_public_subnets)
# }

# resource "aws_internet_gateway" "my_internet_gateway" {
#   name = var.internet_gateway_name
# }

# resource "aws_nat_gateway" "my_nat_gateway" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.private_subnets[0].id
# }
resource "aws_vpc" "my_vpc" {
  cidr_block = var.cidr_block
}

resource "aws_subnet" "public_subnets" {
  count                = var.num_public_subnets
  vpc_id               = aws_vpc.my_vpc.id
  cidr_block           = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnets" {
  count                = var.num_private_subnets
  vpc_id               = aws_vpc.my_vpc.id
  cidr_block           = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + var.num_public_subnets)
}

<<<<<<< HEAD
resource "aws_internet_gateway" "my_internet_gateway" {
=======
resource "aws_internet_gateway" "my_vpc" {
}

}
resource "aws_vpn_gateway" "my_vpc" {
>>>>>>> 8bbf10e1cfd3711fc61669b52cf1c5683261c614
  vpc_id = aws_vpc.my_vpc.id
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.private_subnets[0].id
}
