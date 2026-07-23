data "aws_region" "current" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "n8n" {
  key_name   = "${var.project_name}-key"
  public_key = var.key_pair_public_key
}

# IAM role allowing the instance to read its own secrets from Secrets Manager
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "secrets_access" {
  statement {
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [var.db_credentials_secret_arn, var.n8n_secret_arn]
  }
}

resource "aws_iam_role_policy" "secrets_access" {
  name   = "${var.project_name}-secrets-access"
  role   = aws_iam_role.ec2_role.id
  policy = data.aws_iam_policy_document.secrets_access.json
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_instance" "n8n" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type # t2.micro / t3.micro = Free Tier
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.n8n.key_name
  vpc_security_group_ids = [var.ec2_security_group_id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  root_block_device {
    volume_size = var.root_volume_size # Free Tier: up to 30GB gp2/gp3 total
    volume_type = "gp3"
  }

  user_data = templatefile("${path.module}/user_data.sh.tpl", {
    db_secret_arn  = var.db_credentials_secret_arn
    n8n_secret_arn = var.n8n_secret_arn
    db_endpoint    = var.db_endpoint
    db_name        = var.db_name
    n8n_port       = var.n8n_port
    aws_region     = data.aws_region.current.name
  })

  tags = {
    Name = "${var.project_name}-instance"
  }
}
