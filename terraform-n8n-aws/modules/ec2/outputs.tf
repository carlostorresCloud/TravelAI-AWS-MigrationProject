output "public_ip" {
  value = aws_instance.n8n.public_ip
}

output "instance_id" {
  value = aws_instance.n8n.id
}

output "iam_role_arn" {
  value = aws_iam_role.ec2_role.arn
}
