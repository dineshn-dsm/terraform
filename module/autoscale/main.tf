resource "aws_launch_template" "test" {
  name                    = "${var.asg_name}-ltmpt"
  image_id                = var.ami_id
  instance_type           = var.instance_type
  key_name                = var.key_name
  update_default_version  = var.update_default_version
  vpc_security_group_ids  = var.asg_security_groups
  user_data               = var.user_data_base64
  instance_initiated_shutdown_behavior  = var.shutdown_behaviour
/*
  block_device_mappings {
    device_name   = var.ebs_volume_name_2

    ebs {
      volume_size = var.ebs_volume_size_2
    }
  }
  */

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.tags}-instance"
    }
  }
}


resource "aws_autoscaling_group" "test" {
    name                = "${var.asg_name}-asg"
    desired_capacity    = var.desired_capacity
    max_size            = var.max_size
    min_size            = var.min_size
    vpc_zone_identifier = var.subnet_id
    target_group_arns   = ["${aws_alb_target_group.asgtesttg.id}"]

  launch_template {
    id      = aws_launch_template.test.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_policy" "bat" {
  name                   = "${var.asg_name}-asgpolicy"
  autoscaling_group_name = aws_autoscaling_group.test.name
  policy_type            = "TargetTrackingScaling"
   target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.target_cpu_percent
  }
}

