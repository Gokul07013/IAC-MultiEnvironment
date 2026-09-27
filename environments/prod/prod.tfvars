# ---- Naming / region ----
name        = "mt"
environment = "prod"
region      = "us-east-1"

# ---- Networking ----
cidr            = "20.2.0.0/16"
azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets  = ["20.2.1.0/24", "20.2.2.0/24", "20.2.3.0/24"]
private_subnets = ["20.2.101.0/24", "20.2.102.0/24", "20.2.103.0/24"]

enable_nat_gateway = true
# One NAT gateway per AZ for high availability in production.
single_nat_gateway = false

# ---- Load balancer ----
listener_port     = 80
target_port       = 80
health_check_path = "/"

# ---- ECS service ----
service_name    = "demo"
container_name  = "app"
container_image = "nginx:latest"
container_port  = 80
cpu             = 512
memory          = 1024

assign_public_ip = false

# ---- Autoscaling ----
desired_count            = 3
enable_autoscaling       = true
autoscaling_min_capacity = 3
autoscaling_max_capacity = 10
autoscaling_cpu_target   = 60

# ---- Tags ----
tags = {
  Project     = "mt"
  Environment = "prod"
  ManagedBy   = "terraform"
}
