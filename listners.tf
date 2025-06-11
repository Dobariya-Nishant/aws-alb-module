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