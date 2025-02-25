resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH access to bastion host"
  vpc_id      = aws_vpc.main.id
  # Remove the key_name line - it doesn't belong here

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.1/32"]  # Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = "ami-0e063207e92b63437"  # Or your specific AMI ID
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_1.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  key_name                    = "lampstack"  # The key_name belongs here
  associate_public_ip_address = true
  
  tags = {
    Name = "bastion-host"
  }
}