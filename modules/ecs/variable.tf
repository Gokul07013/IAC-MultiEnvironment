variable "name" {
  type        = string
  description = "Base name used for resource naming (project/prefix)."
}

variable "environment" {
  type        = string
  description = "Environment name, e.g. dev, staging, prod."
}

variable "service_name" {
  type        = string
  description = "Name of the ECS service."
  default     = "demo"
}

variable "cpu" {
  type        = number
  description = "CPU units for the task (256, 512, 1024, ...)."
  default     = 256
}

variable "memory" {
  type        = number
  description = "Memory (MiB) for the task."
  default     = 512
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs where the ECS service runs."
}

variable "assign_public_ip" {
  type        = bool
  description = "Whether to assign a public IP to tasks (needed in public subnets without NAT)."
  default     = false
}

variable "container_name" {
  type        = string
  description = "Name of the container."
  default     = "app"
}

variable "container_image" {
  type        = string
  description = "Container image to run."
  default     = "public.ecr.aws/aws-containers/ecsdemo-frontend:776fd50"
}

variable "container_port" {
  type        = number
  description = "Port the container listens on."
  default     = 80
}

variable "ingress_cidr" {
  type        = string
  description = "CIDR allowed to reach the container port when no ALB is used."
  default     = "0.0.0.0/0"
}

variable "desired_count" {
  type        = number
  description = "Initial number of tasks to run."
  default     = 1
}

variable "health_check_path" {
  type        = string
  description = "HTTP path used by the container-level health check."
  default     = "/"
}

# ---- Load balancer wiring ----

variable "target_group_arn" {
  type        = string
  description = "ALB target group ARN to register tasks into. Null means no ALB."
  default     = null
}

variable "alb_security_group_id" {
  type        = string
  description = "ALB security group ID. When set, only the ALB may reach the tasks."
  default     = null
}

# ---- Autoscaling ----

variable "enable_autoscaling" {
  type        = bool
  description = "Enable target-tracking autoscaling on average CPU."
  default     = false
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "Minimum number of tasks when autoscaling is enabled."
  default     = 1
}

variable "autoscaling_max_capacity" {
  type        = number
  description = "Maximum number of tasks when autoscaling is enabled."
  default     = 3
}

variable "autoscaling_cpu_target" {
  type        = number
  description = "Target average CPU utilization percentage for autoscaling."
  default     = 70
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}
