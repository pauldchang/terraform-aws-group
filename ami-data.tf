data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
    tags = {
    Name = "Data_instance"
  }
}

data "aws_ami" "my_launch_template1" {
  most_recent = true

  filter {
    name   = "name"
    values = ["my-ami-pattern-1"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_ami" "my_launch_template2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["my-ami-pattern-2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
