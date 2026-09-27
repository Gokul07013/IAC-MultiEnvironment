# ---- Naming / region -----
variable "name" {
  type        = string
  description = "Base name / project prefix used in resource names."
}

variable "environment" {
  type        = string
  description = "Environment name, e.g. dev, staging, prod."
}

variable "region" {
  type        = string
  description = "AWS region to deploy into."
}

# ---- Networking ----
variable "cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "azs" {
  type        = list(string)
  description = "Availability zones for the subnets."
}

variable "public_subnets" {
  type        = list(string)
  description = "Public subnet CIDR blocks (used by the ALB)."
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet CIDR blocks (used by the ECS tasks)."
}

variable "enable_nat_gateway" {
  type        = bool
  description = "Create NAT gateway(s) so private subnets can reach the internet."
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use a single shared NAT gateway instead of one per AZ."
}

# ---- Load balancer ----
variable "listener_port" {
  type        = number
  description = "Port the ALB listens on."
}

variable "target_port" {
  type        = number
  description = "Port on the ECS tasks the ALB forwards to."
}

variable "health_check_path" {
  type        = string
  description = "HTTP path used for health checks."
}

# ---- ECS service ----
variable "service_name" {
  type        = string
  description = "Name of the ECS service."
}

variable "container_name" {
  type        = string
  description = "Name of the container."
}

variable "container_image" {
  type        = string
  description = "Container image to run."
}

variable "container_port" {
  type        = number
  description = "Port the container listens on."
}

variable "cpu" {
  type        = number
  description = "CPU units for the task."
}

variable "memory" {
  type        = number
  description = "Memory (MiB) for the task."
}

variable "assign_public_ip" {
  type        = bool
  description = "Assign a public IP to tasks (false when behind an ALB in private subnets)."
}

# ---- Autoscaling ----
variable "desired_count" {
  type        = number
  description = "Initial number of tasks."
}

variable "enable_autoscaling" {
  type        = bool
  description = "Enable target-tracking autoscaling on CPU."
}

variable "autoscaling_min_capacity" {
  type        = number
  description = "Minimum task count when autoscaling."
}

variable "autoscaling_max_capacity" {
  type        = number
  description = "Maximum task count when autoscaling."
}

variable "autoscaling_cpu_target" {
  type        = number
  description = "Target average CPU utilization percentage."
}

# ---- Tags ----
variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
}
