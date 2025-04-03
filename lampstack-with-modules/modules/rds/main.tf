resource "aws_db_subnet_group" "main" {
  name        = "db-subnet-group"
  subnet_ids  = var.db_subnet_ids
  description = "Subnet group for RDS"
}

resource "aws_db_instance" "main" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0.40"
  instance_class         = "db.t3.micro"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.security_group_id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
  parameter_group_name   = aws_db_parameter_group.main.name
}

resource "aws_db_parameter_group" "main" {
  name   = "hospital-app-params"
  family = "mysql8.0"

  parameter {
    name  = "connect_timeout"
    value = "15"
  }
  
  parameter {
    name  = "max_connections"
    value = "100"
  }
}