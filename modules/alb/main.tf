module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.17.0"

  name    = "${var.name}-${var.environment}-alb"
  vpc_id  = var.vpc_id
  subnets = var.subnets

  # Internet-facing by default; set internal = true for private ALBs.
  internal = var.internal

  # Security group for the ALB: allow inbound HTTP from the world,
  # allow all outbound so it can reach the ECS tasks.
  security_group_ingress_rules = {
    http = {
      from_port   = var.listener_port
      to_port     = var.listener_port
      ip_protocol = "tcp"
      cidr_ipv4   = var.ingress_cidr
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  # Target group that the ECS service will register its tasks into.
  target_groups = {
    app = {
      name_prefix = "app-"
      protocol    = "HTTP"
      port        = var.target_port
      target_type = "ip" # Fargate tasks register by IP

      health_check = {
        enabled             = true
        path                = var.health_check_path
        port                = "traffic-port"
        protocol            = "HTTP"
        matcher             = var.health_check_matcher
        healthy_threshold   = 2
        unhealthy_threshold = 3
        interval            = 30
        timeout             = 5
      }

      # The ECS module manages target registration, so don't attach here.
      create_attachment = false
    }
  }

  # Listener that forwards incoming traffic to the target group.
  listeners = {
    http = {
      port     = var.listener_port
      protocol = "HTTP"
      forward = {
        target_group_key = "app"
      }
    }
  }

  tags = var.tags
}
