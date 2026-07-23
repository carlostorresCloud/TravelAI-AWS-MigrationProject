output "db_endpoint" {
  value = aws_db_instance.n8n.address
}

output "db_port" {
  value = aws_db_instance.n8n.port
}

output "db_instance_id" {
  value = aws_db_instance.n8n.id
}
