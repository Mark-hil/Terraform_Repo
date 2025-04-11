#####################################
# Data Sources
#####################################
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

#####################################
# EC2 Instance
#####################################
resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  # Network Configuration
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_groups
  associate_public_ip_address = var.associate_public_ip

  # Root Volume Configuration
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true

    tags = merge(
      var.tags,
      {
        Name = "${var.env_prefix}-web-server-root"
      }
    )
  }

  # User Data
  user_data = fileexists("${path.module}/user_data.sh") ? file("${path.module}/user_data.sh") : null

  # Instance Tags
  tags = merge(
    var.tags,
    {
      Name = "${var.env_prefix}-web-server"
    }
  )

  # Additional Settings
  monitoring    = var.enable_monitoring
  ebs_optimized = var.ebs_optimized

  lifecycle {
    create_before_destroy = true
  }
}