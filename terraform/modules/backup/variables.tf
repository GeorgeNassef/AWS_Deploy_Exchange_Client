variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "resource_arns" {
  description = "List of ARNs of resources to backup"
  type        = list(string)
}

variable "dr_region_vault_arn" {
  description = "ARN of the backup vault in DR region for cross-region copy"
  type        = string
}

variable "daily_schedule" {
  description = "Cron expression for daily backups"
  type        = string
  default     = "cron(0 5 ? * * *)" # Daily at 5 AM UTC
}

variable "weekly_schedule" {
  description = "Cron expression for weekly backups"
  type        = string
  default     = "cron(0 5 ? * SAT *)" # Saturday at 5 AM UTC
}

variable "monthly_schedule" {
  description = "Cron expression for monthly backups"
  type        = string
  default     = "cron(0 5 1 * ? *)" # 1st of each month at 5 AM UTC
}

variable "daily_retention_days" {
  description = "Number of days to retain daily backups"
  type        = number
  default     = 7
}

variable "weekly_retention_days" {
  description = "Number of days to retain weekly backups"
  type        = number
  default     = 30
}

variable "monthly_retention_days" {
  description = "Number of days to retain monthly backups"
  type        = number
  default     = 365
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for backup notifications"
  type        = string
}

variable "enable_cross_region_backup" {
  description = "Enable cross-region backup copy"
  type        = bool
  default     = true
}

variable "enable_continuous_backup" {
  description = "Enable continuous backup for supported resources"
  type        = bool
  default     = true
}

variable "start_window_minutes" {
  description = "The number of minutes after a backup is scheduled before a job is canceled if it doesn't start successfully"
  type        = number
  default     = 60
}

variable "completion_window_minutes" {
  description = "The number of minutes after a backup job is successfully started before it must be completed"
  type        = number
  default     = 120
}

variable "backup_tags" {
  description = "Tags to apply to backup resources"
  type        = map(string)
  default     = {}
}

variable "kms_key_deletion_window" {
  description = "Duration in days after which the KMS key is deleted"
  type        = number
  default     = 7
}

variable "enable_windows_vss" {
  description = "Enable Windows VSS backup"
  type        = bool
  default     = true
}

variable "notification_events" {
  description = "List of backup events to send notifications for"
  type        = list(string)
  default = [
    "BACKUP_JOB_STARTED",
    "BACKUP_JOB_COMPLETED",
    "BACKUP_JOB_FAILED",
    "RESTORE_JOB_STARTED",
    "RESTORE_JOB_COMPLETED",
    "RESTORE_JOB_FAILED"
  ]
}

variable "tags" {
  description = "Additional tags for resources"
  type        = map(string)
  default     = {}
