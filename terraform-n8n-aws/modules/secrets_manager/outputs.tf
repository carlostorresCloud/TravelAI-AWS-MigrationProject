output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_credentials.arn
}

output "n8n_secret_arn" {
  value = aws_secretsmanager_secret.n8n_encryption_key.arn
}
