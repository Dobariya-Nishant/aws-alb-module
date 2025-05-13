resource "aws_security_group" "lb_sg" {
  name        = local.sg_name
  description = "Security Group"
  vpc_id      = var.vpc_id

  tags = merge(
    local.common_tags,
    {
      Name = local.sg_name
    }
  )
}

resource "aws_security_group_rule" "pub_http" {
  count = var.enable_public_access == true && var.enable_http == true ? 1 : 0

  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP"
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "pub_https" {
  count = var.enable_public_access == true && var.enable_https == true ? 1 : 0

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Allow HTTP"
  security_group_id = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "http_security_group_rule" {
  count = var.source_security_group_id != null && var.enable_http == true ? 1 : 0

  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = var.source_security_group_id
  description              = "Allow HTTP"
  security_group_id        = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "https_security_group_rule" {
  count = var.source_security_group_id != null && var.enable_https == true ? 1 : 0

  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = var.source_security_group_id
  description              = "Allow HTTP"
  security_group_id        = aws_security_group.lb_sg.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  description       = "Allow all outbound traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb_sg.id
}