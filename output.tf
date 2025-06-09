output "load_balancer_id" {
  description = "ID of the load balancer"
  value       = aws_lb.this.id
}

output "load_balancer_sg_id" {
  description = "Security group ID attached to the load balancer"
  value       = aws_security_group.lb_sg.id
}
