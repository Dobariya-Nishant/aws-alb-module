output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = aws_lb.alb_loadbalancer.id
}

output "load_balancer_sg_id" {
  description = "Security group ID attached to the load balancer"
  value       = aws_security_group.lb_sg.id
}

output "load_balancer_tg_http_id" {
  description = "ID of the HTTP target group"
  value       = try(aws_lb_target_group.tg_http[0].id, null)
}

output "load_balancer_tg_https_id" {
  description = "ID of the HTTPS target group"
  value       = try(aws_lb_target_group.tg_https[0].id, null)
}

output "load_balancer_tg_http_arn" {
  description = "ARN of the HTTP target group"
  value       = try(aws_lb_target_group.tg_http[0].arn, null)
}

output "load_balancer_tg_https_arn" {
  description = "ARN of the HTTPS target group"
  value       = try(aws_lb_target_group.tg_https[0].arn, null)
}
