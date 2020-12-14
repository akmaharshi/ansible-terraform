resource "aws_lb_target_group" "my-target-group" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "my-app-tg"
  port        = 8080
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "${var.vpc_id}"
}

# resource "aws_lb_target_group_attachment" "my-alb-target-group-attachment1" {
#   count = "${length(aws_instance.Myec2)}"
#   target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
#   target_id        = "${element(aws_instance.Myec2.*.id,count.index)}"
#   port             = 80
# }
resource "aws_lb" "my-aws-alb" {
  name     = "my-app-alb"
  internal = false

  security_groups = [
    "${aws_security_group.my-asg-sg.id}",
  ]

  subnets = [
    "${var.subnet1}",
    "${var.subnet2}",
    "${var.subnet3}",
  ]

  tags = {
    Name = "my-app-alb"
  }

  ip_address_type    = "ipv4"
  load_balancer_type = "application"
}

resource "aws_lb_listener" "my-test-alb-listner" {
  load_balancer_arn = "${aws_lb.my-aws-alb.arn}"
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.my-target-group.arn}"
  }
}