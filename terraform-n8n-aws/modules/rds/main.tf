resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_db_instance" "n8n" {
  identifier     = "${var.project_name}-postgres"
  engine         = "postgres"
  engine_version = var.db_engine_version

  # Free Tier: db.t3.micro / db.t4g.micro, single-AZ, up to 20GB gp2 storage,
  # up to 750 instance-hours/month for 12 months.
  instance_class    = var.db_instance_class
  allocated_storage = var.db_allocated_storage
  storage_type      = "gp2"
  multi_az          = false # Multi-AZ is NOT Free Tier eligible

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_security_group_id]
  publicly_accessible    = false

  backup_retention_period = var.db_backup_retention_days
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled = false # extra retention/cost beyond default is not free

  tags = {
    Name = "${var.project_name}-postgres"
  }
}
