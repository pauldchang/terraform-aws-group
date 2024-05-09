

provider "aws" {
  region = "us-east-2"  # Update with your desired region
}


resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
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
# }

# # Define Auto Scaling Group
# resource "aws_launch_configuration" "ec2_launch_config" {
#   name          = "ec2-launch-config"
#   image_id      = "ami-09b90e09742640522"  # Update with your desired AMI
#   instance_type = "t2.micro"      # Update with your desired instance type

#   security_groups = [aws_security_group.public_sg.id]

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_autoscaling_group" "ec2_asg" {
#   launch_configuration = aws_launch_configuration.ec2_launch_config.id
#   min_size             = 3
#   max_size             = 5
#   desired_capacity     = 3
#   vpc_zone_identifier  = [aws_subnet.public_subnet.id]

#   tag {
#     key                 = "Name"
#     value               = "ec2-instance"
#     propagate_at_launch = true
#   }
# }

# # Define RDS database instances
# resource "aws_db_instance" "db_instance" {
#   count                 = 2
#   allocated_storage     = 20
#   engine                = "mysql"
#   engine_version        = "5.7"
#   instance_class        = "db.t2.micro"
#   username              = "admin"
#   password              = "password"
#   multi_az              = true
#   publicly_accessible   = false
#   db_subnet_group_name  = aws_db_subnet_group.db_subnet_group.name

#   tags = {
#     Name = "db-instance-${count.index}"
#   }
# }

# resource "aws_db_subnet_group" "db_subnet_group" {
#   name       = "my-db-subnet-group"
#   subnet_ids = [aws_subnet.private_subnet.id]
# }
resource "aws_internet_gateway_attachment" "my_vpc" {
  internet_gateway_id = aws_internet_gateway.my_vpc.id
  vpc_id              = aws_vpc.my_vpc.id
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.102.0/24"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.103.0/24"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.101.0/24"
}

resource "aws_internet_gateway" "my_vpc" {}

}
resource "aws_vpn_gateway" "my_vpc" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = 10.0.1.0/24
}
resource "aws_vpn_gateway" "my_vpc" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = 10.0.2.0/24
}
resource "aws_vpn_gateway" "my_vpc" {
  vpc_id = aws_vpc.my_vpc.id
  cidr_block = 10.0.3.0/24
}