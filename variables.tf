locals {
  pre_fix            = "${var.name}-${var.environment}"
  visibility         = var.internal == true ? "public" : "private"
  load_balancer_name = local.pre_fix
  sg_name            = "${local.pre_fix}-alb-sg"  

  listener_rules = flatten([
    for listener_key, listener in var.listeners : [
      for rule in lookup(listener, "rules", []) : {
        listener_key     = listener_key
        listener_arn     = aws_lb_listener.this[listener_key].arn
        path_pattern     = rule.path_pattern
        priority         = rule.priority
        target_group_key = rule.target_group_key
      }
    ]
  ])

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Visibility  = local.visibility
  }
}

variable "project_name" {
  type        = string
  description = "Name of the project. Used for tagging and naming resources."
}

variable "name" {
  type        = string
  description = "Base name for the Application Load Balancer (ALB)."
}

variable "environment" {
  type        = string
  description = "Environment name like dev, staging, or prod. Used in resource naming."
}

variable "availability_zone_ids" {
  type        = list(string)
  description = "List of availability zone IDs for subnet mapping and resource distribution."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB and related resources will be created."
}

variable "subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of private subnet IDs for deploying internal ALB."
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  default     = false
  description = "Enables/disables cross-zone load balancing on the ALB."
}

variable "internal" {
  type        = bool
  default     = true
  description = "Enables/disables cross-zone load balancing on the ALB."
}

variable "securety_group" {
  type = object({
    name = optional(string)
    rules = optional(list(object({
      type            = string
      from_port       = number
      to_port         = number
      protocol        = string
      cidr_blocks     = optional(list(string))
      description     = optional(string)
      security_groups = optional(list(string))
    })))
  })

  default = {
    "name" = null
    "rules" = []
  }
}

variable "target_groups" {
  type = map(object({
    name                          = optional(string)
    target_type                   = optional(string)
    port                          = number
    protocol                      = string
    connection_termination        = optional(bool)
    preserve_client_ip            = optional(string)
    deregistration_delay          = optional(string)
    load_balancing_algorithm_type = optional(string)
    health_check = optional(object({
      enabled             = bool
      port                = number
      path                = optional(string)
      interval            = optional(number)
      healthy_threshold   = optional(number)
      unhealthy_threshold = optional(number)
      timeout             = optional(number)
    }))
  }))
}

variable "listeners" {
  type = map(object({
    port            = number
    target_type     = optional(string)
    protocol        = string
    certificate_arn = optional(string)
    forward = object({
      target_group_key = string
    })
    rules = list(object({
      path_pattern     = list(string)
      priority         = number
      target_group_key = string
    }))
  }))
  description = "List of availability zone IDs for subnet mapping and resource distribution."
}
