

resource "aws_db_instance" "default" {
  identifier                            = var.identifier
  allocated_storage                     = var.storage
  engine                                = var.engine
  engine_version                        = var.engine_version
  instance_class                        = var.instance_class
  name                                  = var.db_name
  username                              = var.username
  password                              = var.password
  vpc_security_group_ids                = [aws_security_group.rds.id]
  db_subnet_group_name                  = aws_db_subnet_group.default.id
  enabled_cloudwatch_logs_exports       = ["postgresql", "upgrade"]
  storage_type                          = "gp2"
  backup_retention_period               = 7
  storage_encrypted                     = false
  max_allocated_storage                 = var.max_allocated_storage
  auto_minor_version_upgrade            = false
  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  skip_final_snapshot                   = true
  publicly_accessible                   = var.publicly_accessible

  tags = {
    "Name"       = "${var.environment}-rds"
    "managed_by" = "terraform"
  }
}

resource "aws_db_subnet_group" "default" {
  name        = "main_subnet_group"
  description = "Our main group of subnets"
  #subnet_ids  = ["${aws_subnet.subnet-a.*.id}", "${aws_subnet.subnet-c.*.id}"]
  subnet_ids = var.private_net_ids
}

resource "aws_security_group" "rds" {
  name   = "${var.environment}-rds-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.rds_ingress_cidr
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"       = "${var.environment}-rds-sg"
    "managed_by" = "terraform"
  }
}