resource "aws_lb_target_group" "tg_http" {
  count = var.enable_http == true ? 1 : 0

  name                          = local.http_target_group_name
  target_type                   = var.target_type
  load_balancing_algorithm_type = var.load_balancing_algorithm
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id

  health_check {
    enabled             = local.enable_health_check
    protocol            = "HTTP"
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.http_target_group_name
    }
  )
}

resource "aws_lb_target_group" "tg_https" {
  count = var.enable_https == true ? 1 : 0

  name                          = local.https_target_group_name
  target_type                   = var.target_type
  load_balancing_algorithm_type = var.load_balancing_algorithm
  port                          = 443
  protocol                      = "HTTPS"
  vpc_id                        = var.vpc_id

  health_check {
    enabled             = local.enable_health_check
    protocol            = "HTTPS"
    path                = var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(
    local.common_tags,
    {
      Name = local.https_target_group_name
    }
  )
}