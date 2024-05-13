provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
 cidr_block = "10.0.0.0/16"
 
 tags = {
   Name = "Project VPC"
 }
}
resource "aws_subnet" "public_subnets" {
  count                  = 3
  vpc_id                 = aws_vpc.main.id
  cidr_block             = "10.0.${count.index}.0/24"
 
}

resource "aws_subnet" "private" {
  count                  = 3
  vpc_id                 = aws_vpc.main.id
  cidr_block             = "10.0.${count.index + 3}.0/24"
}

# Declare subnets

resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.main.id
 
 tags = {
   Name = "Project VPC IG"
 }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_nat_gateway" "nat" {
  count             = 3
  subnet_id         = aws_subnet.private[count.index].id
  allocation_id     = aws_eip.nat[count.index].id
}

resource "aws_eip" "nat" {
  count = 3
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table" "private" {
   count = 3
  vpc_id = aws_vpc.main.id
 
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }

}

resource "aws_route_table_association" "public" {
  count          = 3
  subnet_id      = "${element(aws_subnet.public_subnets.*.id,count.index)}"
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = 3
  subnet_id      = "${element(aws_subnet.private.*.id,count.index)}" 
  route_table_id = aws_route_table.private[count.index].id
}

# add

resource "aws_launch_template" "wordpress" {
  name_prefix   = "wordpress-template-"
  image_id      = "ami-0900fe555666598a2"
  instance_type = "t2.micro"

  # Define user data script to set up WordPress and pass credentials as environment variables
user_data     = <<-EOF
                  #!/bin/bash
                  yum update -y
                  yum install -y httpd php php-mysqlnd
                  systemctl start httpd
                  systemctl enable httpd
                  wget -c https://wordpress.org/latest.tar.gz
                  tar -xvzf latest.tar.gz -C /var/www/html
                  cp -r /var/www/html/wordpress/* /var/www/html/
                  chown -R apache:apache /var/www/html/

                  cat <<EOT >> /var/www/html/wp-config.php
                  define('DB_NAME', '${var.db_name}');
                  define('DB_USER', '${var.db_user}');
                  define('DB_PASSWORD', '${var.db_password}');
                  define('DB_HOST', '${var.db_host}');
                  define('DB_CHARSET', 'utf8');
                  define('DB_COLLATE', '');
                  EOF
}

  # Create an Auto Scaling Group (ASG) using the launch template

resource "aws_launch_template" "asg" {
  name_prefix   = "asg"
  image_id      = "ami-0900fe555666598a2"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "asg" {
  availability_zones = ["us-east-2a"]
  desired_capacity   = 3
  max_size           = 99
  min_size           = 1

launch_template {
    id      = aws_launch_template.wordpress.id
    version = "$Latest"
  }
}

terraform {
  backend "s3" {
    bucket = "paulc-terraform6"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}

# ALB tf
resource "aws_lb" "app_lb" {
  name               = "my-app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = aws_subnet.public_subnets[*].id

  tags = {
    Name = "my-app-lb"
  }
}
resource "aws_security_group" "public_sg" {
  description = "public_sg"
  name = "public_sg"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic from anywhere
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Allow all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }
} 

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "OK"
      status_code  = 200
    }
}
}

resource "aws_lb_target_group" "app_target_group" {
  name     = "my-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }
}

resource "aws_lb_listener_rule" "app_listener_rule" {
  listener_arn = aws_lb_listener.http_listener.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_target_group.arn
  }
  condition {
    host_header {
      values = ["wordpress.pauldchang.com"]  # Replace with your domain name
    }
  }
}

# Data instance
resource "aws_instance" "Data_instance" {
  ami           = data.aws_ami.my_ami.id
  instance_type = "t2.micro"
  key_name      = "SSH-MAC"  
  subnet_id     = "subnet-00468707d5bab7a1a"  
  tags = {
    Name = "data_instance"
  }
}

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

# data of dns 
data "aws_lb" "app_lb" {
  name = "my-app-lb"  # Replace with the name of your ALB
}


resource "aws_route53_record" "alb_record" {
  provider = aws.us-east-2  # Provider alias for the ALB region
  zone_id  = "Z011574713TABDE8M6U0Q"
  name     = "wordpress.pauldchang.com"
  type     = "A"
  alias {
    name                   = data.aws_lb.app_lb.dns_name
    zone_id                = data.aws_lb.app_lb.zone_id
    evaluate_target_health = true
  }
  depends_on = [aws_lb.app_lb]
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "wordpress-db"
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"

  tags = {
    Name = "WordPress Database"
  }
}

#
# Get the DNS endpoint of the RDS instance
data "aws_db_instance" "wordpress_db_info" {
  db_instance_identifier = aws_db_instance.wordpress_db.id
}

# Create Route 53 record for wordpress.pauldchang.com
resource "aws_route53_record" "wordpress_db_record" {
  zone_id = "Z011574713TABDE8M6U0Q"  
  name    = "wordpress.pauldchang.com"
  type    = "CNAME"
  ttl     = 300
  records = [data.aws_db_instance.wordpress_db_info.address]
}
