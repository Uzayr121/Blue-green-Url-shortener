resource "aws_lb" "test" {
  name                       = "ecs-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [var.alb_sg] # reference to the security group of the ALB
  subnets                    = [var.public_subnet_id_1, var.public_subnet_id_2]
  drop_invalid_header_fields = true


}

resource "aws_lb_target_group" "blue-tg" {
  name        = "blue-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol          = "HTTP"
    healthy_threshold = "3"
    path              = "/healthz"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
  


  redirect {
    port        = "443"
    protocol    = "HTTPS"
    status_code = "HTTP_301"
  }
  }



  lifecycle {
    ignore_changes = [default_action]
  }
}


resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.test.arn
  port              = 443
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue-tg.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }

}



resource "aws_lb_target_group" "green-tg" {
  name        = "green-tg"
  port        = 8080
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    protocol          = "HTTP"
    healthy_threshold = "3"
    path              = "/healthz"
  }

}