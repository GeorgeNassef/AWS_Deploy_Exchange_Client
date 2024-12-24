locals {
  name_prefix = "exchange-crm-${var.environment}"
}

data "aws_caller_identity" "current" {}

# AWS Backup Vault
resource "aws_backup_vault" "main" {
  name        = "${local.name_prefix}-vault"
  kms_key_arn = aws_kms_key.backup.arn

  tags = {
    Name        = "${local.name_prefix}-vault"
    Environment = var.environment
  }
}

# KMS Key for Backup Encryption
resource "aws_kms_key" "backup" {
  description             = "KMS key for AWS Backup encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Backup Service"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name        = "${local.name_prefix}-backup-key"
    Environment = var.environment
  }
}

# AWS Backup Plan
resource "aws_backup_plan" "main" {
  name = "${local.name_prefix}-backup-plan"

  rule {
    rule_name         = "daily_backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.daily_schedule

    lifecycle {
      delete_after = var.daily_retention_days
    }

    copy_action {
      destination_vault_arn = var.dr_region_vault_arn
    }
  }

  rule {
    rule_name         = "weekly_backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.weekly_schedule

    lifecycle {
      delete_after = var.weekly_retention_days
    }

    copy_action {
      destination_vault_arn = var.dr_region_vault_arn
    }
  }

  rule {
    rule_name         = "monthly_backup"
    target_vault_name = aws_backup_vault.main.name
    schedule          = var.monthly_schedule

    lifecycle {
      delete_after = var.monthly_retention_days
    }

    copy_action {
      destination_vault_arn = var.dr_region_vault_arn
    }
  }

  advanced_backup_setting {
    backup_options = {
      WindowsVSS = "enabled"
    }
    resource_type = "EC2"
  }

  tags = {
    Name        = "${local.name_prefix}-backup-plan"
    Environment = var.environment
  }
}

# IAM Role for AWS Backup
resource "aws_iam_role" "backup" {
  name = "${local.name_prefix}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "backup.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${local.name_prefix}-backup-role"
    Environment = var.environment
  }
}

# IAM Policy for AWS Backup
resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup.name
}

# Backup Selection
resource "aws_backup_selection" "main" {
  name         = "${local.name_prefix}-backup-selection"
  iam_role_arn = aws_iam_role.backup.arn
  plan_id      = aws_backup_plan.main.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Environment"
    value = var.environment
  }

  resources = var.resource_arns
}

# CloudWatch Alarms for Backup Jobs
resource "aws_cloudwatch_metric_alarm" "backup_job_failed" {
  alarm_name          = "${local.name_prefix}-backup-job-failed"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "BackupJobsFailed"
  namespace           = "AWS/Backup"
  period              = "300"
  statistic           = "Sum"
  threshold           = "0"
  alarm_description   = "This metric monitors failed backup jobs"
  alarm_actions       = [var.sns_topic_arn]

  dimensions = {
    BackupVault = aws_backup_vault.main.name
  }

  tags = {
    Name        = "${local.name_prefix}-backup-job-failed-alarm"
    Environment = var.environment
  }
}
