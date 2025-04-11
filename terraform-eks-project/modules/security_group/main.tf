#####################################
# Security Group Configuration
#####################################
resource "aws_security_group" "main" {
  name_prefix = "${var.env_prefix}-sg-"  # Using name_prefix instead of name for uniqueness
  description = "Security group for ${var.env_prefix} environment"
  vpc_id      = var.vpc_id

  # Prevent automatic name generation collision
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = "${var.env_prefix}-sg"
      Environment = var.env_prefix
    },
    var.tags
  )
}

#####################################
# Ingress Rules
#####################################
resource "aws_security_group_rule" "ssh" {
  type              = "ingress"
  from_port         = local.port_ranges.ssh.from
  to_port           = local.port_ranges.ssh.to
  protocol          = "tcp"
  cidr_blocks       = var.allowed_ssh_cidr_blocks
  security_group_id = aws_security_group.main.id
  description       = "Allow SSH access"
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = local.port_ranges.http.from
  to_port           = local.port_ranges.http.to
  protocol          = "tcp"
  cidr_blocks       = var.allowed_http_cidr_blocks
  security_group_id = aws_security_group.main.id
  description       = "Allow HTTP access"
}

#####################################
# Egress Rules
#####################################
resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = local.port_ranges.all.from
  to_port           = local.port_ranges.all.to
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
  description       = "Allow all outbound traffic"
}