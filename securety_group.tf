resource "aws_security_group" "lb_sg" {
  name     = local.sg_name
  vpc_id   = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.sg_name
    }
  )
}

resource "aws_security_group_rule" "rules" {
  for_each = var.securety_group.rules != null ? var.securety_group.rules : {}

  from_port         = each.value.from_port
  type              = each.value.type
  to_port           = each.value.to_port
  protocol          = each.value.protocol
  cidr_blocks       = each.value.cidr_blocks
  description       = each.value.description
  security_group_id = aws_security_group.lb_sg.id
}