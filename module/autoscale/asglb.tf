resource "aws_lb" "asgtestlb" {
  name               = "asgtest-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.asg_security_groups
  subnets            = var.subnet_id
  tags = {
    Environment      = "${var.tags}-lb"
  }
}



resource "aws_alb_listener" "alb_asg_listener" {  
  load_balancer_arn  = "${aws_lb.asgtestlb.arn}"  
  port               = "${var.asg_listener_port}"  
  protocol           = "${var.asg_listener_protocol}"
  
  default_action {    
    target_group_arn = "${aws_alb_target_group.asgtesttg.arn}"
    type             = "forward"  
  }
}


resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.asgtesttg"]  
  listener_arn = "${aws_alb_listener.alb_asg_listener.arn}" 

  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.asgtesttg.id}"  
  }

  condition {
    path_pattern {
      values = ["${var.asg_listener_path}"]
    }
  }
}

resource "aws_alb_target_group" "asgtesttg" {  
  name     = "asgtest-tg-tf"  
  port     = "${var.asg_listener_port}" 
  protocol = "${var.asg_listener_protocol}"
  vpc_id   = "${var.vpc_id}" 

}