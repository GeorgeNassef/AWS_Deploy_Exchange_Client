variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the Application Load Balancer to associate with WAF"
  type        = string
}

variable "rate_limit" {
  description = "Maximum number of requests allowed from an IP in 5 minutes"
  type        = number
  default     = 2000
}

variable "blocked_countries" {
  description = "List of country codes to block"
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Number of days to retain WAF logs"
  type        = number
  default     = 30
}

variable "enable_logging" {
  description = "Enable WAF logging"
  type        = bool
  default     = true
}

variable "ip_rate_based_rule" {
  description = "Configuration for IP rate-based rule"
  type = object({
    enabled = bool
    limit   = number
  })
  default = {
    enabled = true
    limit   = 2000
  }
}

variable "enable_managed_rules" {
  description = "Map of AWS managed rules to enable"
  type = object({
    common_rule_set          = bool
    sql_injection           = bool
    known_bad_inputs        = bool
    ip_reputation_list      = bool
    admin_protection       = bool
    php_rule_set           = bool
    linux_rule_set         = bool
    windows_rule_set       = bool
  })
  default = {
    common_rule_set     = true
    sql_injection      = true
    known_bad_inputs   = true
    ip_reputation_list = true
    admin_protection  = true
    php_rule_set      = true
    linux_rule_set    = true
    windows_rule_set  = false
  }
}

variable "rule_override_statements" {
  description = "Map of rule override statements"
  type = map(list(object({
    name           = string
    action_to_use = string
  })))
  default = {}
}

variable "ip_whitelist" {
  description = "List of IP addresses or CIDR ranges to whitelist"
  type        = list(string)
  default     = []
}

variable "custom_response_bodies" {
  description = "Map of custom response bodies for blocked requests"
  type = map(object({
    content_type = string
    content      = string
  }))
  default = {}
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

variable "scope" {
  description = "Scope of the WAF ACL (REGIONAL or CLOUDFRONT)"
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "Scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "metric_name_prefix" {
  description = "Prefix for CloudWatch metrics"
  type        = string
  default     = "waf"
}

variable "sampled_requests_enabled" {
  description = "Enable sampled requests for WAF rules"
  type        = bool
  default     = true
}
