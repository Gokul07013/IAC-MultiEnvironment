module "vpc" {
  source = "../../modules/vpc"

  name            = "mt"
  environment     = "dev"
  cidr            = "20.0.0.0/16"
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  public_subnets  = ["20.0.1.0/24", "20.0.2.0/24", "20.0.3.0/24"]
  private_subnets = ["20.0.101.0/24", "20.0.102.0/24", "20.0.103.0/24"]

  # NAT gateway lets tasks in private subnets pull the container image
  # and reach the internet for outbound calls.
  enable_nat_gateway = true

  tags = local.tags
}

module "alb" {
  source = "../../modules/alb"

  name        = "mt"
  environment = "dev"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets # internet-facing ALB lives in public subnets

  listener_port     = 80
  target_port       = 80
  health_check_path = "/"

  tags = local.tags
}

module "ecs" {
  source = "../../modules/ecs"

  name        = "mt"
  environment = "dev"

  service_name    = "demo"
  container_name  = "app"
  container_image = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
  container_port  = 80
  cpu             = 256
  memory          = 512

  # Tasks run in private subnets, only reachable through the ALB.
  subnet_ids       = module.vpc.private_subnets
  assign_public_ip = false

  # Wire the service behind the ALB.
  target_group_arn      = module.alb.target_group_arn
  alb_security_group_id = module.alb.security_group_id
  health_check_path     = "/"

  # Autoscaling: scale tasks between 1 and 4 targeting 70% average CPU.
  desired_count            = 1
  enable_autoscaling       = true
  autoscaling_min_capacity = 1
  autoscaling_max_capacity = 4
  autoscaling_cpu_target   = 70

  tags = local.tags
}
