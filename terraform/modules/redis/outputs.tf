output "replication_group_id" {
  description = "ID of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.main.id
}

output "replication_group_arn" {
  description = "ARN of the ElastiCache replication group"
  value       = aws_elasticache_replication_group.main.arn
}

output "primary_endpoint_address" {
  description = "Address of the primary endpoint"
  value       = aws_elasticache_replication_group.main.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Address of the reader endpoint"
  value       = aws_elasticache_replication_group.main.reader_endpoint_address
}

output "port" {
  description = "Port number of the Redis cluster"
  value       = aws_elasticache_replication_group.main.port
}

output "security_group_id" {
  description = "ID of the Redis security group"
  value       = aws_security_group.redis.id
}

output "parameter_group_id" {
  description = "ID of the Redis parameter group"
  value       = aws_elasticache_parameter_group.main.id
}

output "subnet_group_id" {
  description = "ID of the Redis subnet group"
  value       = aws_elasticache_subnet_group.main.id
}

output "kms_key_id" {
  description = "ID of the KMS key used for encryption"
  value       = aws_kms_key.redis.id
}

output "kms_key_arn" {
  description = "ARN of the KMS key used for encryption"
  value       = aws_kms_key.redis.arn
}

output "auth_token" {
  description = "Authentication token for Redis"
  value       = var.auth_token
  sensitive   = true
}

output "configuration_endpoint" {
  description = "Configuration endpoint for the replication group"
  value       = aws_elasticache_replication_group.main.configuration_endpoint_address
}

output "member_clusters" {
  description = "List of member clusters in the replication group"
  value       = aws_elasticache_replication_group.main.member_clusters
}

output "num_cache_clusters" {
  description = "Number of cache clusters in the replication group"
  value       = aws_elasticache_replication_group.main.number_cache_clusters
}

output "at_rest_encryption_enabled" {
  description = "Whether encryption at rest is enabled"
  value       = aws_elasticache_replication_group.main.at_rest_encryption_enabled
}

output "transit_encryption_enabled" {
  description = "Whether encryption in transit is enabled"
  value       = aws_elasticache_replication_group.main.transit_encryption_enabled
}

output "automatic_failover_enabled" {
  description = "Whether automatic failover is enabled"
  value       = aws_elasticache_replication_group.main.automatic_failover_enabled
}

output "multi_az_enabled" {
  description = "Whether Multi-AZ is enabled"
  value       = aws_elasticache_replication_group.main.multi_az_enabled
}

output "snapshot_retention_limit" {
  description = "Number of days for which ElastiCache retains snapshots"
  value       = aws_elasticache_replication_group.main.snapshot_retention_limit
}

output "snapshot_window" {
  description = "Daily time range during which snapshots are taken"
  value       = aws_elasticache_replication_group.main.snapshot_window
}

output "maintenance_window" {
  description = "Maintenance window for the replication group"
  value       = aws_elasticache_replication_group.main.maintenance_window
}
