resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.lb_security_groups
  subnets            = var.subnet_id
  tags = {
    Environment      = "${var.lb_tags}-lb"
  }
}



resource "aws_alb_listener" "alb_listener" {  
  load_balancer_arn  = "${aws_lb.test.arn}"  
  port               = "${var.alb_listener_port}"  
  protocol           = "${var.alb_listener_protocol}"
  
  default_action {    
    target_group_arn = "${aws_alb_target_group.test.arn}"
    type             = "forward"  
  }
}


resource "aws_alb_listener_rule" "listener_rule" {
  depends_on   = ["aws_alb_target_group.test"]  
  listener_arn = "${aws_alb_listener.alb_listener.arn}" 

  action {    
    type             = "forward"    
    target_group_arn = "${aws_alb_target_group.test.id}"  
  }

  condition {
    path_pattern {
      values = ["${var.alb_listener_path}"]
    }
  }
}


resource "aws_alb_target_group" "test" {  
  name     = "test-tg-tf"  
  port     = "${var.alb_listener_port}" 
  protocol = "${var.alb_listener_protocol}"
  vpc_id   = "${var.vpc_id}" 

}

resource "aws_alb_target_group_attachment" "svc_physical_external" {
  count            =  length(var.instance_id)
  target_group_arn = "${aws_alb_target_group.test.arn}"
  target_id        = "${element(var.instance_id, count.index)}"
  port             = "${var.alb_listener_port}"
}

