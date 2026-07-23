# NOTE ON COST: AWS Secrets Manager has no permanent free tier -- each secret
# gets a 30-day free trial, then is billed at ~$0.40/secret/month plus API
# call charges. For a $0-forever alternative, swap these resources for
# aws_ssm_parameter (type = "SecureString") in the free-tier "Standard"
# parameter tier. Kept as Secrets Manager here since that's what was asked for.

resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project_name}/${var.environment}/db-credentials"
  description = "RDS PostgreSQL credentials for n8n"

  recovery_window_in_days = 0 # allows immediate deletion on destroy; use 7-30 in production
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id

  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    dbname   = var.db_name
    port     = 5432
  })
}

resource "aws_secretsmanager_secret" "n8n_encryption_key" {
  name        = "${var.project_name}/${var.environment}/n8n-encryption-key"
  description = "Encryption key n8n uses to secure stored credentials"

  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "n8n_encryption_key" {
  secret_id     = aws_secretsmanager_secret.n8n_encryption_key.id
  secret_string = var.n8n_encryption_key
}
