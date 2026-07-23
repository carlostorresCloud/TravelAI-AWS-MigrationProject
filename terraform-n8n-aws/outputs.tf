output "n8n_url" {
  description = "URL to access n8n (put behind HTTPS/a domain before production use)"
  value       = "http://${module.ec2.public_ip}:${var.n8n_port}"
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "db_secret_arn" {
  description = "ARN of the Secrets Manager secret holding DB credentials"
  value       = module.secrets_manager.db_secret_arn
}

output "n8n_secret_arn" {
  description = "ARN of the Secrets Manager secret holding the n8n encryption key"
  value       = module.secrets_manager.n8n_secret_arn
}
