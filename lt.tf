resource aws_launch_template "main" {
  name                   = var.name
  update_default_version = true
  image_id               = local.ami
  instance_type          = var.instance_type
}
