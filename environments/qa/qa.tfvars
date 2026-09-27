# ---- Naming / region ----
name        = "mt"
environment = "qa"
region      = "us-east-1"

# ---- Networking ----
cidr            = "20.1.0.0/16"
azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets  = ["20.1.1.0/24", "20.1.2.0/24", "20.1.3.0/24"]
private_subnets = ["20.1.101.0/24", "20.1.102.0/24", "20.1.103.0/24"]

enable_nat_gateway = true
single_nat_gateway = true

# ---- Load balancer ----
listener_port     = 80
target_port       = 80
health_check_path = "/"

# ---- ECS service ----
service_name    = "demo"
container_name  = "app"
container_image = "nginx:latest"
container_port  = 80
cpu             = 256
memory          = 512

assign_public_ip = false

# ---- Autoscaling ----
desired_count            = 2
enable_autoscaling       = true
autoscaling_min_capacity = 2
autoscaling_max_capacity = 6
autoscaling_cpu_target   = 70

# ---- Tags ----
tags = {
  Project     = "mt"
  Environment = "qa"
  ManagedBy   = "terraform"
}
