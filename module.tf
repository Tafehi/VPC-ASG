module "vpc" {
  source = "./vpc"

}

module "backend" {
  source = "./backend"
}

module "asg" {
  source           = "./asg"
  SecurityGroupId  = module.vpc.aws_security_group
  public_subnets   = module.vpc.aws_subnets_public
  aws_elb          = module.elb.aws_elb
  Desired_capacity = var.Desired_capacity
  Min_size         = var.Min_size
  Max_size         = var.Max_size
  # Autoscaling_group_min_size = module.asg.webserver.Autoscaling_group_min_size
}

module "elb" {
  source          = "./elb"
  SecurityGroupId = module.vpc.aws_security_group
  public_subnets  = module.vpc.aws_subnets_public
}
