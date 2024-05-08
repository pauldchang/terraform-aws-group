resource "aws_instance" "my_launch_template" {
  launch_template {
    id      = aws_launch_template.my_launch_template.id
    version = "$Latest"  
  }
    tags = {
    Name = "launch_templaate_instance"
  }
}
resource "aws_instance" "Data_instance" {
  ami           = data.aws_ami.my_ami.id
  instance_type = "t2.micro"
  key_name      = "SSH-MAC"  
  subnet_id     = "subnet-00468707d5bab7a1a"  
  tags = {
    Name = "data_instance"
  }
}