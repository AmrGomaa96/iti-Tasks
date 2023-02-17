resource "aws_lb" "ansible_lb" {
  name               = "app-lb"
  internal           = false
  ip_address_type = "ipv4"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sec_group.id]
  subnets            = [aws_subnet.public1.id,aws_subnet.public2.id]
  tags = {
    Name = "app-lb"
  }
}

resource "aws_lb_target_group" "target_group" {
  name     = "targetGroup1"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.my_vpc.id
  tags = {
    Name = "target_group"
  }
}

resource "aws_lb_target_group_attachment" "attach-priv1" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.private_instance1.id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "attach-priv2" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.private_instance2.id
  port             = 9000
}

resource "aws_lb_listener" "listener1" {
  load_balancer_arn = aws_lb.ansible_lb.arn
  protocol          = "HTTP"
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
