resource "aws_lb_target_group" "this" {
  for_each = var.target_groups

  name = lookup(each.value, "name", "${local.pre_fix}-tg-${each.key}")

  port                          = each.value.port
  protocol                      = each.value.protocol
  vpc_id                        = var.vpc_id
  target_type                   = each.value.target_type
  load_balancing_algorithm_type = each.value.load_balancing_algorithm_type

  # Optional attributes
  connection_termination = lookup(each.value, "connection_termination", null)
  preserve_client_ip     = lookup(each.value, "preserve_client_ip", null)
  deregistration_delay   = lookup(each.value, "deregistration_delay", null)

  dynamic "health_check" {
    for_each = lookup(each.value, "health_check", {}) != {} ? [1] : []
    content {
      enabled             = each.value.health_check.enabled
      interval            = each.value.health_check.interval
      path                = each.value.health_check.path
      port                = each.value.health_check.port
      healthy_threshold   = each.value.health_check.healthy_threshold
      unhealthy_threshold = each.value.health_check.unhealthy_threshold
      timeout             = each.value.health_check.timeout
    }
  }

  tags = merge(
    local.common_tags,
    {
      Name = lookup(each.value, "name", "${local.pre_fix}-tg-${each.key}")
    }
  )
}