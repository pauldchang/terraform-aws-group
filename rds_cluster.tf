resource "aws_db_subnet_group" "default" {
  name        = "test-subnet-group"
  description = "Terraform example RDS subnet group"

  subnet_ids  = [aws_subnet.private[0].id, aws_subnet.private[1].id, aws_subnet.private[2].id]
}

resource "aws_db_instance" "writer" {
  allocated_storage    = 10
  db_name              = "admin"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.default.name
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = false

  vpc_security_group_ids = [aws_security_group.projectsec.id]
  skip_final_snapshot    = true
}

resource "aws_db_instance" "reader1" {
  allocated_storage    = 10
  db_name              = "writer_db"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  db_subnet_group_name = aws_db_subnet_group.default.name
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql8.0"
  publicly_accessible  = false
  vpc_security_group_ids = [aws_security_group.projectsec.id]
  skip_final_snapshot    = true
}