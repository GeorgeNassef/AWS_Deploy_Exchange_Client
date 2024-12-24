output "web_acl_id" {
  description = "ID of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "ARN of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_capacity" {
  description = "Current capacity of the WAF Web ACL"
  value       = aws_wafv2_web_acl.main.capacity
}

output "web_acl_rules" {
  description = "List of rules in the WAF Web ACL"
  value = [
    for rule in aws_wafv2_web_acl.main.rule : {
      name     = rule.name
      priority = rule.priority
    }
  ]
}

output "web_acl_association_id" {
  description = "ID of the WAF Web ACL Association"
  value       = aws_wafv2_web_acl_association.main.id
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group for WAF logs"
  value       = aws_cloudwatch_log_group.waf.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group for WAF logs"
  value       = aws_cloudwatch_log_group.waf.arn
}

output "logging_configuration" {
  description = "WAF logging configuration details"
  value = {
    enabled              = var.enable_logging
    log_destination     = aws_cloudwatch_log_group.waf.arn
    retention_days      = var.log_retention_days
  }
}

output "rate_limit_rule" {
  description = "Details of the rate limiting rule"
  value = {
    enabled = var.ip_rate_based_rule.enabled
    limit   = var.ip_rate_based_rule.limit
  }
}

output "managed_rules" {
  description = "List of enabled AWS managed rules"
  value = {
    common_rule_set     = var.enable_managed_rules.common_rule_set
    sql_injection      = var.enable_managed_rules.sql_injection
    known_bad_inputs   = var.enable_managed_rules.known_bad_inputs
    ip_reputation_list = var.enable_managed_rules.ip_reputation_list
    admin_protection  = var.enable_managed_rules.admin_protection
    php_rule_set      = var.enable_managed_rules.php_rule_set
    linux_rule_set    = var.enable_managed_rules.linux_rule_set
    windows_rule_set  = var.enable_managed_rules.windows_rule_set
  }
}

output "geo_match_rule" {
  description = "Geographic blocking rule configuration"
  value = {
    enabled          = length(var.blocked_countries) > 0
    blocked_countries = var.blocked_countries
  }
}

output "ip_whitelist" {
  description = "List of whitelisted IP addresses/ranges"
  value       = var.ip_whitelist
  sensitive   = true
}

output "metrics_prefix" {
  description = "Prefix used for CloudWatch metrics"
  value       = var.metric_name_prefix
}

output "scope" {
  description = "Scope of the WAF ACL deployment"
  value       = var.scope
}

output "tags" {
  description = "Tags applied to the WAF resources"
  value       = var.tags
}
