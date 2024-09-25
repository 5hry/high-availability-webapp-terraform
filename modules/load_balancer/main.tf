
resource "aws_lb_target_group" "web_app_TG" {
  name     = "web-app-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}



resource "aws_lb_listener" "alb_listener_https" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_app_TG.arn
  }
}

resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets_id
  depends_on         = [var.internet_gw]
  tags = {
    Name = "Load Balancer",
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "alb-security-group"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id # Replace with your VPC ID

  # Ingress rule for allowing HTTP traffic (port 80)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic from all IPs
  }

  # Ingress rule for allowing HTTPS traffic (port 443)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Egress rule for allowing all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-security-group"
  }
}
