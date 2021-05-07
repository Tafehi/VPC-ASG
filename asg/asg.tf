# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ASG
# ---------------------------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_autoscaling_group" "webserver" {
  launch_configuration = aws_launch_configuration.as_conf.id
  vpc_zone_identifier  = var.public_subnets
  name                 = "${var.environment}-asg"
  load_balancers       = [var.aws_elb.name]
  health_check_type    = "ELB"
  desired_capacity     = var.Desired_capacity
  min_size             = var.Min_size
  max_size             = var.Max_size
  tags = [{
    Name = var.environment
  }]

}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE LAUNCH CONFIGURATION
# This defines what runs on each EC2 Instance in the ASG. 
# ---------------------------------------------------------------------------------------------------------------------
resource "aws_launch_configuration" "as_conf" {
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.instance_type
  security_groups = [var.SecurityGroupId.id]
  name            = "${var.environment}-lunch-Temp-Conf"
  # Add userData to install Docker and run nginx
  user_data = <<-EOF
            resource "docker_container" "nginx-server" {
            name = "nginx-server-1"
            image = docker_image.nginx.latest
            ports {
                internal = 80
                external = 8081
            }
            volumes {
                container_path  = "/usr/share/nginx/html"
                host_path = "/tmp/tutorial/www"
                read_only = true
            }
            }
            EOF
  #   <<-EOF
  #                 #!/bin/bash
  #                 sudo apt update
  #                 sudo apt install docker -y

  #                 EOF

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}






