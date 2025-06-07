locals {
  pre_fix             = "${var.name}-${var.environment}"
  visibility          = var.enable_public_access == true ? "public" : "private"
  subnet_ids          = concat(var.public_subnet_ids, var.private_subnet_ids)
  load_balancer_name  = local.pre_fix
  enable_health_check = var.target_type == "instance" ? true : var.enable_health_check
  sg_name             = "${local.pre_fix}-alb-sg"
  http_listener_name  = "${local.pre_fix}-http"
  https_listener_name = "${local.pre_fix}-https"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    Visibility  = local.visibility
  }
  port_mappings = {
    HTTP  = 80
    HTTPS = 443
    SSH   = 443
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

variable "source_security_group_id" {
  type        = string
  default     = null
  description = "Optional: Security group ID for allowing specific inbound traffic sources."
}

variable "listeners" {
  type = list(object({
    name                = optional(string)
    protocol            = string
    certificate_arn     = optional(string)
  }))
}

variable "target_groups" {
  type = map(object({
    name                     = optional(string)
    target_type              = optional(string)
    protocol                 = string
    health_check_path        = optional(string)
    enable_health_check      = optional(bool)
    load_balancing_algorithm = optional(string)
  }))
}
