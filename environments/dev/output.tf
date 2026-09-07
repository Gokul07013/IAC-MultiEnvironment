output "alb_dns_name" {
  description = "Public DNS name of the ALB. Open this in a browser to reach the service."
  value       = module.alb.dns_name
}
