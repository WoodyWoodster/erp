resource "aws_lb" "main" {
  name               = "gndwrk-erp-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.public_2.id]

  tags = {
    Name = "gndwrk-erp-alb"
  }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "gndwrk-erp-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path     = "/up"
    interval = 30
    timeout  = 5
  }
}
