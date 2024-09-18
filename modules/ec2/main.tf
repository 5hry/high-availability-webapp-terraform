resource "aws_launch_template" "instances_configuration" {
  name_prefix            = "asg-instance"
  image_id               = var.ami_name
  key_name               = var.key_name
  instance_type          = var.instance_type
  user_data              = filebase64("./install_script.sh")
  vpc_security_group_ids = [aws_security_group.private_subnet_sg.id]
  iam_instance_profile {
    name = data.aws_iam_instance_profile.web_app_instance_profile.name
  }
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "asg-instance"
  }
}

data "aws_iam_instance_profile" "web_app_instance_profile" {
  name = "web-app-ec2"
}

resource "aws_instance" "bastion_ec2" {
  ami                         = var.ami_name
  key_name                    = var.key_name
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.public_subnet_sg.id]
  subnet_id                   = var.public_subnets_id[0]
  associate_public_ip_address = true
}


resource "aws_autoscaling_group" "asg" {
  name                      = "asg"
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  health_check_grace_period = 150
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.private_subnets_id
  target_group_arns         = [var.target_group_arn]
  launch_template {
    id      = aws_launch_template.instances_configuration.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "Webapp"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "avg_cpu_policy_greater" {
  name                   = "avg-cpu-policy-greater"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.id
  # CPU Utilization is above 50
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 40.0
  }

}

resource "aws_security_group" "private_subnet_sg" {
  vpc_id      = var.vpc_id
  name        = "Private Subnet SG"
  description = "Allow SSH from public subnet"

  ingress {
    description     = "SSH ingress"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.public_subnet_sg.id, ]
  }
  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["27.2.17.184/32", "0.0.0.0/0"]
  }

  # Ingress rule to allow all ICMP traffic
  ingress {
    from_port   = -1            # Allows all types of ICMP traffic
    to_port     = -1            # Allows all ICMP codes
    protocol    = "icmp"        # Protocol for ICMP
    cidr_blocks = ["0.0.0.0/0"] # Allows traffic from all IPs
  }
  ingress {
    description = "SSH ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all traffic to internet"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  tags = {
    Name = "Private Subnet SG"
  }
}

resource "aws_security_group" "public_subnet_sg" {
  vpc_id      = var.vpc_id
  name        = "Public Subnet SG"
  description = "Allow SSH from public subnet"

  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["27.2.17.184/32", ]
  }

  ingress {
    description = "SSH ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "Allow all traffic to internet"
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
  }
  tags = {
    Name = "Private Subnet SG"
  }
}
