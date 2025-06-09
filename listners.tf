# resource "aws_lb_listener" "http_listener" {
#   count               = length(var.listeners) 
#   load_balancer_arn   = aws_lb.alb_loadbalancer.arn
#   port                = var.listeners[count.index].
#   protocol            = "HTTP"

#   default_action

#   tags = merge( 
#     local.common_tags,
#     {
#       Name = local.http_listener_name
#     }
#   )
# }

# resource "aws_lb_listener_rule" "api_rule" {
#   listener_arn = aws_lb_listener.http_listener.arn
#   priority     = 100

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.api.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/*"]
#     }
#   }
# }

# resource "aws_lb_listener" "https" {
#   count = var.enable_https_listener == true && var.certificate_arn != null ? 1 : 0

#   load_balancer_arn = aws_lb.alb_loadbalancer.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tg_https[0].arn
#   }

#   tags = merge(
#     local.common_tags,
#     {
#       Name = local.https_target_group_name
#     }
#   )
# }


resource "aws_lb_listener" "this" {
  for_each = var.listeners

  load_balancer_arn = aws_lb.this.arn
  port              = each.value.port
  protocol          = each.value.protocol

  # TLS Specific
  certificate_arn = lookup(each.value, "certificate_arn", null)

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.forward.target_group_key].arn
  }

  tags = merge(
    local.common_tags,
    {
      Name = each.key
    }
  )
}

resource "aws_lb_listener_rule" "this" {
  for_each = {
    for idx, rule in local.listener_rules : "${rule.listener_key}-${rule.priority}" => rule
  }

  listener_arn = each.value.listener_arn
  priority     = each.value.priority

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[each.value.target_group_key].arn
  }

  condition {
    path_pattern {
      values = each.value.path_pattern
    }
  }
}