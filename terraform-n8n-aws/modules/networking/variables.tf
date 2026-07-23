variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "allowed_n8n_cidr" {
  type = string
}

variable "n8n_port" {
  type = number
}
