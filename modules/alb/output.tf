output "arn" {
  description = "ARN of the ALB."
  value       = module.alb.arn
}

output "dns_name" {
  description = "Public DNS name of the ALB (use this to reach the service)."
  value       = module.alb.dns_name
}

output "security_group_id" {
  description = "Security group ID attached to the ALB."
  value       = module.alb.security_group_id
}

output "target_group_arn" {
  description = "ARN of the 'app' target group the ECS service registers into."
  value       = module.alb.target_groups["app"].arn
}
