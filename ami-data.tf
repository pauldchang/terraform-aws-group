data "aws_ami" "my_launch_template1" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ami-0900fe555666598a2"] 
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# data "aws_ami" "my_launch_template2" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ami-0900fe555666598a2"]  
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
# }
