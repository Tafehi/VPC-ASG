# ---------------------------------------------------------------------------------------------------------------------
# CREATE A cert.pem file for SSL certification regarding HTTPS
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_iam_server_certificate" "https_cert" {
  name_prefix      = "https_cert"
  certificate_body = file(var.PATH_TO_Cert)
  private_key      = file(var.PATH_TO_Key)

  lifecycle {
    create_before_destroy = true
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE AN ELB TO ROUTE TRAFFIC ACROSS THE ASG
# ---------------------------------------------------------------------------------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_elb" "elb" {
  name    = var.environment
  subnets = var.public_subnets
  #   availability_zones = data.aws_availability_zones.available.names
  security_groups = [var.SecurityGroupId.id]

  listener {
    lb_port            = var.elb_port
    lb_protocol        = "https"
    instance_port      = var.server_port
    instance_protocol  = "https"
    ssl_certificate_id = aws_iam_server_certificate.https_cert.arn
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    target              = "HTTPS:${var.server_port}/"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A SECURITY GROUP FOR THE ELB
# ---------------------------------------------------------------------------------------------------------------------

# resource "aws_security_group" "elb" {
#   name        = "${var.environment}-elb"
#   description = "Security Group for the ELB (ALB)"
#   egress {
#     from_port   = 0
#     protocol    = "-1"
#     to_port     = 0
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   ingress {
#     from_port   = var.elb_port
#     protocol    = "tcp"
#     to_port     = var.elb_port
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }




