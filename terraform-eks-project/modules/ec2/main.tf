resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_groups
  user_data              = file("${path.module}/user_data.sh")

  tags = merge(
    {
      Name = "${var.env_prefix}-web-server"
    },
    var.tags
  )
}

resource "aws_eip" "web" {
  instance = aws_instance.web.id
  domain   = "vpc"

  tags = var.tags
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# resource "aws_eip" "web" {
#   instance = aws_instance.web.id
#   domain   = "vpc"  # Updated from vpc = true
# }