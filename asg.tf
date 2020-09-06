resource aws_autoscaling_group "main" {
  name     = var.name
  min_size = 0
  max_size = 0
  //health_check_grace_period = 300
  //health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Default"
  }
  vpc_zone_identifier = var.subnets
}
