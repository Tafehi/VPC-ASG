
variable "environment" {
  description = "Environment name"
  default     = "EM"
}

variable "SecurityGroupId" {
  description = "sg ID"
}

variable "instance_type" {
  default = "t2.micro"
}


variable "public_subnets" {
  description = "List of private subnet IDs"
}


variable "aws_elb" {
  description = "aws Elastic load balancer"
}

variable "Desired_capacity" {}
variable "Min_size" {}
variable "Max_size" {}
