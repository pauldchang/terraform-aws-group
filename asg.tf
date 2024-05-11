# resource "aws_launch_template" "wordpress" {
#   name_prefix   = "wordpress-template-"
#   instance_type = "t2.micro"

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "wordpress-instance"
#     }
#   }

#   block_device_mappings {
#     device_name = "/dev/xvda"
#     ebs {
#       volume_size = 20
#       volume_type = "gp2"
#     }
#   }
# }

# resource "aws_autoscaling_group" "wordpress_asg" {
#   name                 = "wordpress-asg"
#   min_size             = 1
#   max_size             = 99
#   desired_capacity     = 1
#   launch_template {
#     id      = aws_launch_template.wordpress.id
#     version = "$Latest"
#   }

#   tag {
#     key                 = "Name"
#     value               = "wordpress-instance"
#     propagate_at_launch = true
#   }

#   target_group_arns = ["${aws_lb_target_group.wordpress.arn}"]
# }