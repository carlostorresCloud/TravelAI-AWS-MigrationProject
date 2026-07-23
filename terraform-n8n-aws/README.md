# n8n on AWS — Terraform

This repo deploys a self-hosted n8n stack on AWS using:
- EC2 with Docker
- RDS PostgreSQL
- Secrets Manager for secrets

It is designed for small test use and to stay within the AWS free tier as much as possible.

## What is included

- `providers.tf` — Terraform and AWS provider setup
- `variables.tf` — inputs you can change
- `main.tf` — wires the modules together
- `outputs.tf` — useful outputs like public IP and secret ARNs
- `terraform.tfvars.example` — copy this to `terraform.tfvars`
- `modules/`
  - `networking/` — VPC, public subnets, route table, security groups
  - `ec2/` — EC2 instance for n8n, key pair, IAM role
  - `rds/` — PostgreSQL database
  - `secrets_manager/` — stores DB credentials and n8n encryption key

## Before you deploy

1. Copy `terraform.tfvars.example` to `terraform.tfvars`.
2. Set `key_pair_public_key`, `allowed_ssh_cidr`, and `allowed_n8n_cidr`.
3. Do not commit `.tfstate`, `.tfvars`, or `.terraform/`.

## Requirements

- Terraform 1.5 or newer
- AWS CLI configured with appropriate AWS credentials
- SSH key pair for the EC2 instance

## Deploy

```bash
cp terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars
terraform init
terraform plan
terraform apply
```

After apply, the output shows the public IP. Access n8n at:

`http://<public-ip>:5678`

It may take a minute or two for the instance to finish startup.

## Cost notes

- EC2 and RDS can fit the AWS free tier for new accounts.
- Secrets Manager is not free long-term.
- No NAT Gateway is used here.

## Important security advice

- Do not leave `allowed_ssh_cidr` or `allowed_n8n_cidr` as `0.0.0.0/0` in production.
- Keep secrets in AWS Secrets Manager, not in Git.
- Move Terraform state to remote storage if you use this beyond testing.

## Destroy

```bash
terraform destroy
```
