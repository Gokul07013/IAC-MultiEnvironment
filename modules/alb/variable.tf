variable "name" {
  type        = string
  description = "Base name used for resource naming (project/prefix)."
}

variable "environment" {
  type        = string
  description = "Environment name, e.g. dev, staging, prod."
}

variable "vpc_id" {
  type        = string
  description = "VPC in which to create the ALB and its security group."
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs for the ALB (public subnets for an internet-facing ALB)."
}

variable "internal" {
  type        = bool
  description = "Whether the ALB is internal (private) instead of internet-facing."
  default     = false
}

variable "listener_port" {
  type        = number
  description = "Port the ALB listens on for incoming traffic."
  default     = 80
}

variable "target_port" {
  type        = number
  description = "Port on the targets (ECS tasks) that the ALB forwards to."
  default     = 80
}

variable "ingress_cidr" {
  type        = string
  description = "CIDR allowed to reach the ALB listener."
  default     = "0.0.0.0/0"
}

variable "health_check_path" {
  type        = string
  description = "HTTP path the target group health check requests."
  default     = "/"
}

variable "health_check_matcher" {
  type        = string
  description = "HTTP status code(s) considered healthy."
  default     = "200-399"
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources."
  default     = {}
}
