# Create a launch template for the WordPress instance
resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-template-"
  image_id      = "ami-0900fe555666598a2"
  instance_type = "t2.large"
  key_name      = "local"   
  count = 1
  network_interfaces {
  security_groups = [aws_security_group.public_sg.id, aws_security_group.public_sg.id]
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public[count.index].id
  delete_on_termination       = true 
}

user_data     = base64encode (<<-EOF
                  #!/bin/bash
                  yum update -y
                  yum install -y httpd php php-mysqlnd
                  systemctl start httpd
                  systemctl enable httpd
                  wget -c https://wordpress.org/latest.tar.gz
                  tar -xvzf latest.tar.gz -C /var/www/html
                  cp -r /var/www/html/wordpress/* /var/www/html/
                  chown -R apache:apache /var/www/html/
                  mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
                  sed -i "s/database_name_here/admin/" /var/www/html/wp-config.php
                  sed -i "s/username_here/admin/" /var/www/html/wp-config.php
                  sed -i "s/password_here/password/" /var/www/html/wp-config.php
                  sed -i "s/localhost/${aws_db_instance.writer.endpoint}/" /var/www/html/wp-config.php
                  EOF
                  )
}

# Create an Auto Scaling group for WordPress
# resource "aws_autoscaling_group" "asg" {
#   availability_zones = ["us-east-2a", "us-east-2b", "us-east-2c"]
#   desired_capacity   = 3
#   max_size           = 99
#   min_size           = 1
#   launch_template {
#     id      = aws_launch_template.wordpress.id
#     version = "$Latest"
#   }
#   tag {
#     key                 = "Name"
#     value               = "wordpress-asg"
#     propagate_at_launch = true
#   }
# }

# Create auto scaling

resource "aws_autoscaling_group" "asg" {
  name = "wordpress-asg"

  launch_template {
    id = aws_launch_template.wordpress[0].id
    # vesrion = "$Latest"
  }

  min_size             = 1
  max_size             = 10
  desired_capacity     = 3 
  health_check_type    = "EC2"
  health_check_grace_period = 300  
  vpc_zone_identifier = [aws_subnet.public[0].id, aws_subnet.public[1].id, aws_subnet.public[2].id,]
}

# Create an Application Load Balancer
# resource "aws_lb" "app_lb" {
#   name               = "my-app-lb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.public_sg.id]
#   subnets            = aws_subnet.public_subnets[*].id
#   tags = {
#     Name = "my-app-lb"
#   }
# }

# # Create an ALB

resource "aws_lb" "app_alb" {
  name               = "my-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.projectsec1.id]       # needt to change
  #subnets            = concat(aws_subnet.public[*].id, aws_subnet.private[*].id)
  subnets            = concat(aws_subnet.public[*].id)
  tags = {
    Name = "my-app-lb"
  }
}

# Create a listener for the ALB
resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
}

# Create a target group for the ALB
# resource "aws_lb_target_group" "app_target_group" {
#   name     = "my-app-tg"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.main.id

  resource "aws_lb_target_group" "Wordpress_TG" {
   name     = "learn-asg-terramino"
   port     = 80
   protocol = "HTTP"
   vpc_id   = aws_vpc.main.id
 }

resource "aws_autoscaling_attachment" "wordpress_AAA" {
  autoscaling_group_name = aws_autoscaling_group.asg.id
  lb_target_group_arn  = aws_lb_target_group.Wordpress_TG.arn
  
}