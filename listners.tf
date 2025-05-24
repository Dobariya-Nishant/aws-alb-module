resource "aws_lb_listener" "http_listener" {
  count = var.enable_http == true ? 1 : 0

  load_balancer_arn = aws_lb.alb_loadbalancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_http[0].arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.http_listener_name
    }
  )
}

resource "aws_lb_listener" "https" {
  count = var.enable_https == true && var.certificate_arn != null ? 1 : 0

  load_balancer_arn = aws_lb.alb_loadbalancer.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_https[0].arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.https_target_group_name
    }
  )
}
