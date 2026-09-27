module "vpc" {
  source = "../../modules/vpc"

  name            = var.name
  environment     = var.environment
  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway

  tags = var.tags
}

module "alb" {
  source = "../../modules/alb"

  name        = var.name
  environment = var.environment

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  listener_port     = var.listener_port
  target_port       = var.target_port
  health_check_path = var.health_check_path

  tags = var.tags
}

module "ecs" {
  source = "../../modules/ecs"

  name        = var.name
  environment = var.environment

  service_name    = var.service_name
  container_name  = var.container_name
  container_image = var.container_image
  container_port  = var.container_port
  cpu             = var.cpu
  memory          = var.memory

  # Tasks run in private subnets, only reachable through the ALB.
  subnet_ids       = module.vpc.private_subnets
  assign_public_ip = var.assign_public_ip

  # Wire the service behind the ALB.
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.security_group_id
  health_check_path     = var.health_check_path

  # Autoscaling.
  desired_count            = var.desired_count
  enable_autoscaling       = var.enable_autoscaling
  autoscaling_min_capacity = var.autoscaling_min_capacity
  autoscaling_max_capacity = var.autoscaling_max_capacity
  autoscaling_cpu_target   = var.autoscaling_cpu_target

  tags = var.tags
}
