provider "aws" {
  region = var.aws_region
}

terraform {
  backend "s3" {
    bucket         = "exchange-crm-terraform-state"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "networking" {
  source = "../../modules/networking"

  environment     = var.environment
  vpc_cidr        = var.vpc_cidr
  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
}

module "ecs" {
  source = "../../modules/ecs"

  environment      = var.environment
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnet_ids
  public_subnets  = module.networking.public_subnet_ids

  frontend_image   = var.frontend_image
  backend_image    = var.backend_image
  domain_name     = var.domain_name
  certificate_arn = var.certificate_arn

  frontend_cpu    = 1024
  frontend_memory = 2048
  backend_cpu     = 2048
  backend_memory  = 4096

  desired_count   = 2
  
  depends_on = [module.networking]
}

module "rds" {
  source = "../../modules/rds"

  environment     = var.environment
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.private_subnet_ids

  engine_version = "13.7"
  instance_class = "db.r6g.xlarge"
  multi_az       = true

  database_name  = var.database_name
  master_username = var.database_username
  master_password = var.database_password

  backup_retention_period = 30
  deletion_protection    = true

  depends_on = [module.networking]
}

module "redis" {
  source = "../../modules/redis"

  environment     = var.environment
  vpc_id         = module.networking.vpc_id
  subnet_ids     = module.networking.private_subnet_ids

  node_type      = "cache.r6g.xlarge"
  num_cache_nodes = 2
  
  automatic_failover_enabled = true
  multi_az_enabled          = true

  auth_token     = var.redis_auth_token
  
  depends_on = [module.networking]
}

module "monitoring" {
  source = "../../modules/monitoring"

  environment     = var.environment
  vpc_id         = module.networking.vpc_id
  
  ecs_cluster_name = module.ecs.cluster_name
  rds_instance_id  = module.rds.instance_id
  redis_cluster_id = module.redis.cluster_id

  alarm_email     = var.alarm_email
  
  depends_on = [
    module.ecs,
    module.rds,
    module.redis
  ]
}

module "waf" {
  source = "../../modules/waf"

  environment = var.environment
  alb_arn    = module.ecs.alb_arn

  rate_limit = 2000
  
  depends_on = [module.ecs]
}

module "backup" {
  source = "../../modules/backup"

  environment = var.environment
  
  rds_instance_arn = module.rds.instance_arn
  efs_arn          = module.ecs.efs_arn

  retention_period = 30
  
  depends_on = [
    module.rds,
    module.ecs
  ]
}
