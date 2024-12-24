variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Redis cluster will be created"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the Redis cluster"
  type        = list(string)
}

variable "ecs_security_group_id" {
  description = "Security group ID of the ECS tasks"
  type        = string
}

variable "node_type" {
  description = "ElastiCache node type"
  type        = string
  default     = "cache.t3.medium"
}

variable "num_cache_clusters" {
  description = "Number of cache clusters in the replication group"
  type        = number
  default     = 2
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  type        = bool
  default     = true
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "Auth token for Redis authentication"
  type        = string
  sensitive   = true
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for CloudWatch alarms"
  type        = string
}

variable "parameter_family" {
  description = "ElastiCache parameter group family"
  type        = string
  default     = "redis6.x"
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "snapshot_retention_limit" {
  description = "Number of days to retain snapshots"
  type        = number
  default     = 7
}

variable "snapshot_window" {
  description = "Time window when snapshots are taken"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Time window for maintenance"
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit"
  type        = bool
  default     = true
}

variable "notification_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
}

variable "alarm_cpu_threshold" {
  description = "CPU utilization threshold for alarm"
  type        = number
  default     = 75
}

variable "alarm_memory_threshold" {
  description = "Memory threshold in bytes for alarm"
  type        = number
  default     = 100000000 # 100MB
}

variable "alarm_connections_threshold" {
  description = "Connections threshold for alarm"
  type        = number
  default     = 5000
}
