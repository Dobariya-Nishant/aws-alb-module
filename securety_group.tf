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
  count = length(var.securety_group.rules)

  from_port         = var.securety_group.rules[count.index].from_port
  type              = var.securety_group.rules[count.index].type
  to_port           = var.securety_group.rules[count.index].to_port
  protocol          = var.securety_group.rules[count.index].protocol
  cidr_blocks       = var.securety_group.rules[count.index].cidr_blocks
  description       = var.securety_group.rules[count.index].description
  security_group_id = aws_security_group.lb_sg.id
}