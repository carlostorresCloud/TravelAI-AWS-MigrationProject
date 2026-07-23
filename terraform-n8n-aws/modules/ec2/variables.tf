variable "project_name" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "root_volume_size" {
  type = number
}

variable "subnet_id" {
  type = string
}

variable "ec2_security_group_id" {
  type = string
}

variable "key_pair_public_key" {
  type = string
}

variable "n8n_port" {
  type = number
}

variable "db_credentials_secret_arn" {
  type = string
}

variable "n8n_secret_arn" {
  type = string
}

variable "db_endpoint" {
  type = string
}

variable "db_name" {
  type = string
}
