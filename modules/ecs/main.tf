module "ecs" {
  source  = "terraform-aws-modules/ecs/aws"
  version = "7.6.0"

  cluster_name = "${var.name}-${var.environment}-ecs"

  # Use Fargate capacity providers (no EC2 instances to manage)
  cluster_capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy = {
    FARGATE = {
      weight = 100
      base   = 1
    }
    FARGATE_SPOT = {
      weight = 0
    }
  }

  services = {
    (var.service_name) = {
      cpu    = var.cpu
      memory = var.memory

      # How many tasks to run. When autoscaling is on, this is just the
      # starting point; the scaling policy adjusts it afterwards.
      desired_count = var.desired_count

      # Run the service in the given subnets (private subnets when behind an ALB)
      subnet_ids       = var.subnet_ids
      assign_public_ip = var.assign_public_ip

      container_definitions = {
        (var.container_name) = {
          essential = true
          image     = var.container_image

          port_mappings = [
            {
              name          = var.container_name
              containerPort = var.container_port
              protocol      = "tcp"
            }
          ]

          readonly_root_filesystem  = false
          enable_cloudwatch_logging = true

          # Container-level health check: ECS runs this command inside the
          # container to decide whether the task itself is healthy.
          health_check = {
            command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}${var.health_check_path} || exit 1"]
            interval    = 30
            timeout     = 5
            retries     = 3
            startPeriod = 60
          }
        }
      }

      # Register this service's tasks into the ALB target group so the load
      # balancer can route traffic to them. Only wired when a target group
      # ARN is provided.
      load_balancer = var.target_group_arn == null ? {} : {
        app = {
          target_group_arn = var.target_group_arn
          container_name   = var.container_name
          container_port   = var.container_port
        }
      }

      # ---- Autoscaling (target tracking on average CPU) ----
      enable_autoscaling       = var.enable_autoscaling
      autoscaling_min_capacity = var.autoscaling_min_capacity
      autoscaling_max_capacity = var.autoscaling_max_capacity

      autoscaling_policies = var.enable_autoscaling ? {
        cpu = {
          policy_type = "TargetTrackingScaling"
          target_tracking_scaling_policy_configuration = {
            predefined_metric_specification = {
              predefined_metric_type = "ECSServiceAverageCPUUtilization"
            }
            target_value = var.autoscaling_cpu_target
          }
        }
      } : {}

      # Allow inbound on the container port. When an ALB security group is
      # provided, only the ALB may reach the tasks; otherwise fall back to a
      # raw CIDR (useful for a quick no-ALB setup).
      security_group_ingress_rules = var.alb_security_group_id != null ? {
        from_alb = {
          description                  = "Container port from ALB"
          from_port                    = var.container_port
          to_port                      = var.container_port
          ip_protocol                  = "tcp"
          referenced_security_group_id = var.alb_security_group_id
        }
        } : {
        app = {
          description = "Container port"
          from_port   = var.container_port
          to_port     = var.container_port
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
    }
  }

  tags = var.tags
}
