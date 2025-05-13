resource "aws_lb" "alb_loadbalancer" {
  name               = local.load_balancer_name
  internal           = !var.enable_public_access
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = local.subnet_ids

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = merge(
    local.common_tags,
    {
      Name = local.load_balancer_name
    }
  )
}