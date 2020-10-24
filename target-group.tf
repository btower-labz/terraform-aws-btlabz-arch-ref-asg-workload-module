# See: https://github.com/terraform-providers/terraform-provider-aws/issues/636
resource "random_id" "lb_tg" {
  keepers = {
    name        = var.name
    wl_port     = var.wl_port
    ht_interval = var.ht_interval
    ht_path     = var.ht_path
    ht_port     = var.ht_port
    ht_timeout  = var.ht_timeout
    ht_ok_codes = local.ht_ok_codes_matcher
    vpc_id      = data.aws_vpc.main.id
  }
  byte_length = 4
}

locals {
  ht_ok_codes_matcher = join(",", sort(distinct(compact(var.ht_ok_codes))))
}

resource "aws_lb_target_group" "main" {
  name     = format("%s-%s-tg", var.name, random_id.lb_tg.hex)
  port     = var.wl_port
  protocol = "HTTP" # Force HTTP

  deregistration_delay          = var.deregistration_delay
  slow_start                    = var.slow_start
  load_balancing_algorithm_type = var.load_balancing_algorithm_type

  health_check {
    enabled  = true
    interval = var.ht_interval
    path     = var.ht_path
    port     = var.ht_port
    protocol = "HTTP" # Force HTTP
    timeout  = var.ht_timeout
    matcher  = local.ht_ok_codes_matcher
  }

  # Force stateless
  stickiness {
    type    = "lb_cookie"
    enabled = false
  }

  vpc_id = data.aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    map(
      "Workload", "local.name",
      "Service", "service1"
    ),
    var.tags
  )
}

resource "aws_autoscaling_attachment" "main" {
  autoscaling_group_name = aws_autoscaling_group.main.id
  alb_target_group_arn   = aws_lb_target_group.main.arn
}

resource "aws_lb_listener_rule" "main" {
  listener_arn = var.lb_listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  # Path condition
  condition {
    path_pattern {
      values = var.wl_paths
    }
  }

  # Host condition
  dynamic "condition" {
    for_each = var.hostnames
    content {
      host_header {
        values = [condition.value]
      }
    }
  }

}

output "tg_arn" {
  description = "Workload ALB Target Group ARN."
  value       = aws_lb_target_group.main.arn
}
