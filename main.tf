resource aws_autoscaling_group "main" {
  name             = var.name
  min_size         = var.asg_min
  max_size         = var.asg_max
  desired_capacity = var.asg_desired
  //health_check_grace_period = 300
  //health_check_type         = "ELB"
  launch_template {
    id      = aws_launch_template.main.id
    version = "$Default"
  }
  vpc_zone_identifier = local.subnets
  lifecycle {
    ignore_changes = [
      desired_capacity
    ]
  }

  tag {
    key   = "Name"
    value = var.name
    # We will take care of instance and volume names in lt specification
    propagate_at_launch = false
  }

  dynamic "tag" {
    for_each = var.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}

resource aws_launch_template "main" {
  name                   = var.name
  update_default_version = true
  image_id               = local.ami
  instance_type          = var.instance_type
  iam_instance_profile {
    arn = aws_iam_instance_profile.main.arn
  }
  instance_initiated_shutdown_behavior = "terminate"
  vpc_security_group_ids               = local.security_groups

  tag_specifications {
    # E.g. tags for management, backups, DNS registration etc.
    resource_type = "instance"
    tags = merge(
      map(
        "Name", var.name,
        "InstanceSpecific", "foo"
      ),
      var.tags
    )
  }

  tag_specifications {
    # E.g. tags for maintenance and backups
    resource_type = "volume"
    tags = merge(
      map(
        "Name", var.name,
        "VolumeSpecific", "bar"
      ),
      var.tags
    )
  }

  # TODO
  #tag_specifications {
  #  resource_type = "elastic-gpu"
  #  tags = merge(
  #    map(
  #      "Name", var.name
  #    ),
  #    var.tags
  #  )
  #}

  #tag_specifications {
  #  resource_type = "spot-instances-request"
  #  tags = merge(
  #    map(
  #      "Name", var.name
  #    ),
  #    var.tags
  #  )
  #}

  user_data = local.userdata

  tags = merge(
    map(
      "Name", var.name
    ),
    var.tags
  )

}
