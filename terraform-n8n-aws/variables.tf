variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name used to prefix/tag resources"
  type        = string
  default     = "n8n"
}

variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets. RDS requires a subnet group spanning >= 2 AZs even in single-AZ mode."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "availability_zones" {
  description = "Availability zones to use, matching public_subnet_cidrs order"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "instance_type" {
  description = "EC2 instance type. t2.micro / t3.micro are AWS Free Tier eligible (750 hrs/month for 12 months)"
  type        = string
  default     = "t3.micro"
}

variable "ec2_root_volume_size" {
  description = "Root EBS volume size in GB (Free Tier covers up to 30GB gp2/gp3 total)"
  type        = number
  default     = 30
}

variable "key_pair_public_key" {
  description = "Public key material (contents of e.g. ~/.ssh/id_ed25519.pub) used to create the EC2 key pair"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to SSH into the EC2 instance. Restrict this to your own IP in production."
  type        = string
  default     = "0.0.0.0/0"
}

variable "allowed_n8n_cidr" {
  description = "CIDR allowed to access the n8n web UI. Restrict this to your own IP in production."
  type        = string
  default     = "0.0.0.0/0"
}

variable "n8n_port" {
  description = "Port n8n listens on"
  type        = number
  default     = 5678
}

variable "db_instance_class" {
  description = "RDS instance class. db.t3.micro / db.t4g.micro are Free Tier eligible"
  type        = string
  default     = "db.t3.micro"
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.4"
}

variable "db_allocated_storage" {
  description = "Allocated storage in GB (Free Tier covers up to 20GB gp2)"
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Name of the n8n database"
  type        = string
  default     = "n8n"
}

variable "db_username" {
  description = "Master username for RDS"
  type        = string
  default     = "n8n_admin"
}

variable "db_backup_retention_days" {
  description = "Automated backup retention period, in days"
  type        = number
  default     = 1
}

variable "n8n_encryption_key" {
  description = "Encryption key n8n uses to secure stored credentials. Leave empty to auto-generate one."
  type        = string
  default     = ""
  sensitive   = true
}
