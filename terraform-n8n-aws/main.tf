module "networking" {
  source = "./modules/networking"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  allowed_ssh_cidr    = var.allowed_ssh_cidr
  allowed_n8n_cidr    = var.allowed_n8n_cidr
  n8n_port            = var.n8n_port
}

resource "random_password" "db_password" {
  length           = 20
  special          = true
  override_special = "!#$%^&*()-_=+"
}

resource "random_password" "n8n_encryption_key" {
  count   = var.n8n_encryption_key == "" ? 1 : 0
  length  = 32
  special = false
}

module "secrets_manager" {
  source = "./modules/secrets_manager"

  project_name = var.project_name
  environment  = var.environment

  db_username = var.db_username
  db_password = random_password.db_password.result
  db_name     = var.db_name

  n8n_encryption_key = var.n8n_encryption_key != "" ? var.n8n_encryption_key : random_password.n8n_encryption_key[0].result
}

module "rds" {
  source = "./modules/rds"

  project_name             = var.project_name
  subnet_ids               = module.networking.public_subnet_ids
  rds_security_group_id    = module.networking.rds_security_group_id
  db_instance_class        = var.db_instance_class
  db_engine_version        = var.db_engine_version
  db_allocated_storage     = var.db_allocated_storage
  db_name                  = var.db_name
  db_username              = var.db_username
  db_password              = random_password.db_password.result
  db_backup_retention_days = var.db_backup_retention_days
}

module "ec2" {
  source = "./modules/ec2"

  project_name          = var.project_name
  instance_type         = var.instance_type
  root_volume_size      = var.ec2_root_volume_size
  subnet_id             = module.networking.public_subnet_ids[0]
  ec2_security_group_id = module.networking.ec2_security_group_id
  key_pair_public_key   = var.key_pair_public_key
  n8n_port              = var.n8n_port

  db_credentials_secret_arn = module.secrets_manager.db_secret_arn
  n8n_secret_arn            = module.secrets_manager.n8n_secret_arn

  db_endpoint = module.rds.db_endpoint
  db_name     = var.db_name

  depends_on = [module.rds]
}
