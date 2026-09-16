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

          portMappings = [
            {
              name          = var.container_name
              containerPort = var.container_port
              protocol      = "tcp"
            }
          ]

          readonlyRootFilesystem  = false
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
      # balancer can route traffic to them. Static key "app"; the target
      # group ARN is known only after apply, which is fine for a value.
      load_balancer = {
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

      # Allow inbound on the container port only from the ALB.
      #
      # The map key ("app") is a static literal so Terraform can build the
      # for_each set at plan time. The ALB security group id is only known
      # after apply, but that's fine: unknown *values* are allowed, only
      # unknown *keys* are not.
      security_group_ingress_rules = {
        app = {
          description                  = "Container port from ALB"
          from_port                    = var.container_port
          to_port                      = var.container_port
          ip_protocol                  = "tcp"
          referenced_security_group_id = var.alb_security_group_id
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
