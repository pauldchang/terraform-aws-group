resource "aws_launch_template" "my_ec2_launch_template1" {
  name_prefix   = "my_ec2_launch_template"
  image_id      = data.aws_ami.my_launch_template1.id  
  instance_type = "t2.micro"
}

resource "aws_launch_template" "my_ec2_launch_template2" {
  name_prefix   = "my_ec2_launch_template"
  image_id      = data.aws_ami.my_launch_template2.id  
  instance_type = "t2.micro"
}


# resource "aws_launch_template" "my_launch_template1" {
#   name_prefix   = "my_launch_template1"
#   image_id      = data.aws_ami.my_launch_template1.id
#   instance_type = "t2.micro"
# }

# resource "aws_launch_template" "my_launch_template2" {
#   name_prefix = "my_launch_template2"
#   image_id    = data.aws_ami.my_launch_template2.id
# }

# resource "aws_autoscaling_group" "my_autoscaling_group" {
#   availability_zones = ["us-east-2a"]
#   desired_capacity   = 2
#   max_size           = 5
#   min_size           = 1

#   mixed_instances_policy {
#     launch_template {
#       launch_template_specification {
#         launch_template_id = aws_launch_template.my_launch_template1.id
#       }

#       override {
#         instance_type     = "t2.micro"
#         weighted_capacity = "3"
#       }

#       override {
#         instance_type = "t2.micro"
#         launch_template_specification {
#           launch_template_id = aws_launch_template.my_launch_template2.id
#         }
#         weighted_capacity = "2"
#       }
#     }
#   }
# }
