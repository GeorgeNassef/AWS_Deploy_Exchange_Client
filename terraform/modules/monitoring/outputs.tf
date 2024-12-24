output "sns_topic_arn" {
  description = "ARN of the SNS topic for alarms"
  value       = aws_sns_topic.alarms.arn
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "dashboard_arn" {
  description = "ARN of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_arn
}

output "log_groups" {
  description = "Map of log group names and their ARNs"
  value = {
    frontend = {
      name = aws_cloudwatch_log_group.ecs_frontend.name
      arn  = aws_cloudwatch_log_group.ecs_frontend.arn
    }
    backend = {
      name = aws_cloudwatch_log_group.ecs_backend.name
      arn  = aws_cloudwatch_log_group.ecs_backend.arn
    }
  }
}

output "metric_alarms" {
  description = "Map of CloudWatch metric alarms and their ARNs"
  value = {
    ecs_cpu = {
      name = aws_cloudwatch_metric_alarm.ecs_cpu.alarm_name
      arn  = aws_cloudwatch_metric_alarm.ecs_cpu.arn
    }
    alb_5xx = {
      name = aws_cloudwatch_metric_alarm.alb_5xx.alarm_name
      arn  = aws_cloudwatch_metric_alarm.alb_5xx.arn
    }
  }
}

output "composite_alarms" {
  description = "Map of CloudWatch composite alarms and their ARNs"
  value = {
    system_health = {
      name = aws_cloudwatch_composite_alarm.system_health.alarm_name
      arn  = aws_cloudwatch_composite_alarm.system_health.arn
    }
  }
}

output "log_metric_filters" {
  description = "Map of CloudWatch log metric filters and their names"
  value = {
    error_logs = {
      name      = aws_cloudwatch_log_metric_filter.error_logs.name
      log_group = aws_cloudwatch_log_metric_filter.error_logs.log_group_name
      pattern   = aws_cloudwatch_log_metric_filter.error_logs.pattern
    }
  }
}

output "alarm_topic_subscriptions" {
  description = "List of subscriptions to the alarm SNS topic"
  value = {
    email = {
      topic_arn = aws_sns_topic.alarms.arn
      protocol  = "email"
      endpoint  = var.alarm_email
    }
  }
}

output "monitoring_configuration" {
  description = "Monitoring configuration details"
  value = {
    log_retention_days        = var.log_retention_days
    detailed_monitoring      = var.enable_detailed_monitoring
    container_insights       = var.enable_container_insights
    anomaly_detection       = var.enable_anomaly_detection
    dashboard_refresh       = var.dashboard_refresh_interval
    evaluation_periods     = var.alarm_evaluation_periods
    period_seconds        = var.alarm_period_seconds
  }
}

output "alarm_thresholds" {
  description = "Configured alarm thresholds"
  value = {
    cpu_utilization     = var.cpu_utilization_threshold
    memory_utilization  = var.memory_utilization_threshold
    error_rate         = var.error_rate_threshold
    latency           = var.latency_threshold_seconds
  }
}
