# ---- Naming / region ----
name        = "mt"
environment = "dev"
region      = "us-east-1"

# ---- Networking ----
cidr            = "20.0.0.0/16"
azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets  = ["20.0.1.0/24", "20.0.2.0/24", "20.0.3.0/24"]
private_subnets = ["20.0.101.0/24", "20.0.102.0/24", "20.0.103.0/24"]

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
desired_count            = 1
enable_autoscaling       = true
autoscaling_min_capacity = 1
autoscaling_max_capacity = 4
autoscaling_cpu_target   = 70

# ---- Tags ----
tags = {
  Project     = "mt"
  Environment = "dev"
  ManagedBy   = "terraform"
}
