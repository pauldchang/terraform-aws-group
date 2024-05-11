# # # resource "aws_instance" "ec2_instance" {
# # #   count         = 3
# # #   ami           = "ami-0900fe555666598a2"  # Change this to your desired AMI
# # #   instance_type = "t2.micro"  # Change this to your desired instance type
# # # }

# # # resource "aws_db_instance" "db_instance" {
# # #   count           = 2
# # #   instance_class  = "db.t2.micro"  # Change this to your desired instance class
# # #   engine          = "mysql"  # Change this to your desired database engine
# # #   engine_version  = "5.7"  # Change this to your desired database engine version
# # #   allocated_storage = 2  # Change this to your desired allocated storage in GB
# # # }

# # # resource "aws_autoscaling_group" "asg" {
# # #   launch_configuration = aws_launch_configuration.ec2_launch_config.name
# # #   min_size             = 3  # Minimum number of instances
# # #   max_size             = 6  # Maximum number of instances
# # #   desired_capacity     = 3  # Desired number of instances
# # # }

# # # resource "aws_launch_configuration" "ec2_launch_config" {
# # #   name_prefix          = "group-"
# # #   image_id             = "ami-0900fe555666598a2"  # Change this to your desired AMI
# # #   instance_type        = "t2.micro"  # Change this to your desired instance type
# # # }
# # resource "aws_vpc" "my_vpc" {
# #   cidr_block = var.cidr_block
# # }

# # resource "aws_subnet" "public_subnets" {
# #   count                = var.num_public_subnets
# #   vpc_id               = aws_vpc.my_vpc.id
# #   cidr_block           = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index)
# #   map_public_ip_on_launch = true
# # }

# # resource "aws_subnet" "private_subnets" {
# #   count                = var.num_private_subnets
# #   vpc_id               = aws_vpc.my_vpc.id
# #   cidr_block           = cidrsubnet(aws_vpc.my_vpc.cidr_block, 8, count.index + var.num_public_subnets)
# # }

# # resource "aws_internet_gateway" "my_internet_gateway" {
# #   name = var.internet_gateway_name
# # }

# # resource "aws_nat_gateway" "my_nat_gateway" {
# #   allocation_id = aws_eip.nat.id
# #   subnet_id     = aws_subnet.private_subnets[0].id
# # }
# resource "aws_vpc" "my_vpc" {
#   cidr_block = var.cidr_block
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
#   vpc_id = aws_vpc.my_vpc.id
# }

# # Create Elastic IP for NAT Gateway
# resource "aws_eip" "nat" {
#   domain = "vpc"
# }

# resource "aws_nat_gateway" "my_nat_gateway" {
#   allocation_id = aws_eip.nat.id
#   subnet_id     = aws_subnet.private_subnets[0].id
# }
provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "./module/vpc"
}