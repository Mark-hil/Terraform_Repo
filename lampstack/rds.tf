resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group"
  subnet_ids = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = {
    Name = "rds-subnet-group"
  }
}

resource "aws_db_instance" "mysql" {
  identifier             = "mysql-db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = "admin"
  password               = "admin_123456"
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = false
}


# Add a time delay to ensure RDS is fully available
# resource "time_sleep" "wait_for_db" {
#   depends_on = [aws_db_instance.mysql]
#   create_duration = "90s"
# }

# resource "mysql_database" "hms" {
#   name = "hms"
# }

# resource "null_resource" "import_sql" {
#   depends_on = [mysql_database.hms]

#   provisioner "local-exec" {
#     command = "mysql -h ${aws_db_instance.mysql.endpoint} -u admin -p'admin_123456' hms < hms.sql"
#   }
# }