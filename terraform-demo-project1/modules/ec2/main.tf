data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's owner ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  user_data                   = file("${path.module}/user_data.sh")
  associate_public_ip_address = true  # ← This enables public IP
#   key_name                    = aws_key_pair.ssh_key.key_name  # Required for SSH access
  
  tags = {
    Name = "${var.project_name}-ec2"
  }
}

# Add this resource for SSH access (create this key pair in AWS console first)
# resource "aws_key_pair" "ssh_key" {
#   key_name   = "${var.project_name}-key"
#   public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key
# }