data "aws_ami" "amazon-linux-2" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
  owners = ["amazon"]
  
}


resource "aws_launch_configuration" "my-test-launch-config" {
  image_id        = "data.aws_ami.amazon-linux-2.id"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.my-asg-sg.id}"]
  key_name = "mykey"
  iam_instance_profile = "ec2-s3"
  user_data = <<-EOF
              #!/bin/sh
              yum install -y java-1.8.0-openjdk
              # yum install -y tomcat
              # aws s3 cp s3://sai-petclinic/81f8102d-c371-4991-bf51-669d3e2d903b/petclinic/petclinic.war /usr/share/tomcat/webapps/
              # chown tomcat:tomcat /usr/share/tomcat/webapps/*.war
              # systemctl restart tomcat 
              EOF

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_security_group" "my-asg-sg" {
  name   = "my-asg-sg"
  vpc_id = "${var.vpc_id}"
}

resource "aws_security_group_rule" "inbound_ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 22
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "inbound_http" {
  from_port         = 8080
  protocol          = "tcp"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 8080
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "outbound_all" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = "${aws_security_group.my-asg-sg.id}"
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.my-test-launch-config.name}"
  vpc_zone_identifier  = ["${var.subnet1}","${var.subnet2 }","${var.subnet3}"]
  target_group_arns    = ["${aws_lb_target_group.my-target-group.arn}"]
  health_check_type    = "EC2"

  min_size = 1
  max_size = 2

  tag {
    key                 = "Name"
    value               = "my-app-asg"
    propagate_at_launch = true
  }
}

