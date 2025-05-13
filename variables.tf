locals {
  post_fix                = "${var.alb_name}-${var.environment}"
  visibility              = var.enable_public_access == true ? "public" : "private"
  subnet_ids              = length(var.public_subnet_ids) > 0 ? var.public_subnet_ids : var.private_subnet_ids
  load_balancer_name      = local.post_fix
  enable_health_check     = var.target_type == "instance" ? true : var.enable_health_check
  sg_name                 = "alb-sg-${local.post_fix}"
  http_target_group_name  = "http-tg-${local.post_fix}"
  https_target_group_name = "https-tg-${local.post_fix}"
  http_listener_name      = "http-${local.post_fix}"
  https_listener_name     = "https-${local.post_fix}"
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

variable "alb_name" {
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

variable "enable_public_access" {
  type        = bool
  default     = false
  description = "Set to true if ALB should be internet-facing. Requires public subnets."

  validation {
    condition     = !(var.enable_public_access == true && length(var.public_subnet_ids) == 0)
    error_message = "At least one public subnet is required to enable public access."
  }
}

variable "public_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of public subnet IDs for deploying internet-facing ALB."
}

variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "List of private subnet IDs for deploying internal ALB."
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  default     = true
  description = "Enables/disables cross-zone load balancing on the ALB."
}

variable "enable_health_check" {
  type        = bool
  default     = false
  description = "Enable health checks for the target groups."
}

variable "health_check_path" {
  type        = string
  default     = "/"
  description = "The destination path used by the load balancer to perform health checks on targets (e.g. '/', '/health')."
}

variable "source_security_group_id" {
  type        = string
  default     = null
  description = "Optional: Security group ID for allowing specific inbound traffic sources."
}

variable "enable_http" {
  type        = bool
  default     = false
  description = "Set to true to enable HTTP listener on the ALB."
}

variable "enable_https" {
  type        = bool
  default     = false
  description = "Set to true to enable HTTPS listener on the ALB."
}

variable "target_type" {
  type        = string
  default     = "instance"
  description = "Target type for the target group. Valid values: instance, ip, lambda."
}

variable "load_balancing_algorithm" {
  type        = string
  default     = "round_robin"
  description = "Load balancing algorithm to distribute traffic. Options: round_robin, least_outstanding_requests (for ALB), weighted_round_robin (for NLB)."
}

variable "certificate_arn" {
  type        = string
  default     = ""
  description = "ARN of the SSL certificate for HTTPS listener. Required if enable_https is true."

  validation {
    condition     = !(var.enable_https == true && length(var.certificate_arn) == 0)
    error_message = "certificate_arn is needed for enabling https"
  }
}
