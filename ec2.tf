resource "aws_instance" "Data_instance" {
  count         = 2
  ami           = data.aws_ami.my_ami.id
  instance_type = "t2.micro"
  key_name      = "SSH-MAC"  
  subnet_id     = "subnet-00468707d5bab7a1a"  
  tags = {
    Name = "data_instance"
  }
}

resource "aws_launch_template" "my_launch_template" {
  name_prefix   = "my_launch_template"
  image_id      = "ami-0900fe555666598a2"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "my_launch_template" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 3
  max_size           = 5
  min_size           = 1

  launch_template {
    id      = aws_launch_template.group.id
    version = "$Latest"
  }
}