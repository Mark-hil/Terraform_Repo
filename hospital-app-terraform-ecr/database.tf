resource "aws_db_instance" "mysql" {
  identifier           = "hospital-db"
  engine               = "mysql"
  engine_version       = "8.0.40"
  instance_class       = "db.t3.micro"
  allocated_storage    = 20
  username             = var.db_username
  password             = var.db_password
  db_name              = "hms"
  skip_final_snapshot  = true
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name = aws_db_subnet_group.main.name
}

resource "aws_db_subnet_group" "main" {
  name       = "hospital-db-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}

resource "aws_security_group" "db" {
  name   = "hospital-db-sg"
  vpc_id = aws_vpc.main.id
  
  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"
    security_groups = [aws_security_group.ecs.id]
  }
}