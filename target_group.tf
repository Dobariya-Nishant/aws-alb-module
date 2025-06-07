resource "aws_lb_target_group" "tg_confing" {
  count = length(var.target_group_config)

  name = coalesce(
    lookup(var.target_group_config[count.index], "name", null),
    "${local.pre_fix}-tg-${count.index}"
  )

  target_type = coalesce(
    lookup(var.target_group_config[count.index], "target_type", null),
    "instance"
  )

  load_balancing_algorithm_type = coalesce(
    lookup(var.target_group_config[count.index], "load_balancing_algorithm", null),
    "round_robin"
  )

  port = lookup(
    local.port_mappings,
    upper(var.target_group_config[count.index].protocol),
    80
  )

  protocol = coalesce(
    lookup(var.target_group_config[count.index], "protocol", null),
    "HTTP"
  )

  vpc_id = var.vpc_id

  health_check {
    enabled = coalesce(
      lookup(var.target_group_config[count.index], "enable_health_check", null),
      false
    )

    protocol = coalesce(
      lookup(var.target_group_config[count.index], "protocol", null),
      "HTTP"
    )

    path = coalesce(
      lookup(var.target_group_config[count.index], "health_check_path", null),
      "/"
    )

    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = merge(
    local.common_tags,
    {
      Name = coalesce(
        lookup(var.target_group_config[count.index], "name", null),
        "${local.pre_fix}-tg-${count.index}"
      )
    }
  )
}
