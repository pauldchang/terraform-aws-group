
resource "aws_launch_template" "my_launch_template" {
  name = "my_launch_template"

  block_device_mappings {
    device_name = "/dev/sdf"

    ebs {
      volume_size = 20
    }
  }

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  credit_specification {
    cpu_credits = "standard"
  }

  disable_api_termination = true

  ebs_optimized = true

  image_id = data.aws_ami.my_ami.id

  instance_initiated_shutdown_behavior = "terminate"

  instance_market_options {
    market_type = "spot"
  }

  instance_type = "t2.micro"

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  monitoring {
    enabled = true
  }

  placement {
    availability_zone = "us-east-2"
  }

  vpc_security_group_ids = ["sg-0a84f04b52c33cf96"]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "launch_template_instance"
    }
  }

}