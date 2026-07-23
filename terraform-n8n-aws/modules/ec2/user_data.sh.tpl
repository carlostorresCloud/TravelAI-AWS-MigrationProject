#!/bin/bash
set -euo pipefail

dnf install -y docker jq aws-cli
systemctl enable --now docker

# Pull DB credentials and n8n encryption key from Secrets Manager at boot,
# so nothing sensitive is ever written into the Terraform state or AMI.
DB_SECRET=$(aws secretsmanager get-secret-value --secret-id "${db_secret_arn}" --region "${aws_region}" --query SecretString --output text)
N8N_KEY=$(aws secretsmanager get-secret-value --secret-id "${n8n_secret_arn}" --region "${aws_region}" --query SecretString --output text)

DB_USER=$(echo "$DB_SECRET" | jq -r .username)
DB_PASS=$(echo "$DB_SECRET" | jq -r .password)

docker run -d \
  --name n8n \
  --restart unless-stopped \
  -p ${n8n_port}:5678 \
  -e DB_TYPE=postgresdb \
  -e DB_POSTGRESDB_HOST="${db_endpoint}" \
  -e DB_POSTGRESDB_PORT=5432 \
  -e DB_POSTGRESDB_DATABASE="${db_name}" \
  -e DB_POSTGRESDB_USER="$DB_USER" \
  -e DB_POSTGRESDB_PASSWORD="$DB_PASS" \
  -e N8N_ENCRYPTION_KEY="$N8N_KEY" \
  -e N8N_PORT=5678 \
  -v n8n_data:/home/node/.n8n \
  docker.n8n.io/n8nio/n8n
