resource "aws_lb" "this" {
  name               = local.load_balancer_name
  internal           = !var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids

  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing

  tags = merge(
    local.common_tags,
    {
      Name = local.load_balancer_name
    }
  )
}
