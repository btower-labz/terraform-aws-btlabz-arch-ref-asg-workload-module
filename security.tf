variable "security_groups" {
  type        = list
  description = "Additional security groups for the workload"
  default     = []
}

variable "workload_egress_cidr" {
  type    = list
  default = ["0.0.0.0/0"]
}

variable "workload_ingress_cidr" {
  type    = list
  default = []
}

variable "workload_ingress_sgs" {
  type    = list
  default = []
}

locals {
  security_groups = sort(concat(
    list(aws_security_group.workload.id),
    distinct(compact(var.security_groups))
  ))
}

resource "aws_security_group" "workload" {
  name        = format("%s-wl-sg", var.name)
  description = "Allow Workload Access"
  vpc_id      = data.aws_vpc.main.id
  tags = merge(
    map(
      "Name", format("%s-sg", var.name)
    ),
    var.tags
  )
}

resource "aws_security_group_rule" "workload_default_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = var.workload_egress_cidr
  security_group_id = aws_security_group.workload.id
}

resource "aws_security_group_rule" "workload_in_app_cidr" {
  count             = length(var.workload_ingress_cidr) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = var.wl_port
  to_port           = var.wl_port
  protocol          = "tcp"
  cidr_blocks       = var.workload_ingress_cidr
  security_group_id = aws_security_group.workload.id
}

# Create only if ht is on separate port
resource "aws_security_group_rule" "workload_in_ht_cidr" {
  count             = length(var.workload_ingress_cidr) > 0 && var.wl_port != var.ht_port ? 1 : 0
  type              = "ingress"
  from_port         = var.ht_port
  to_port           = var.ht_port
  protocol          = "tcp"
  cidr_blocks       = var.workload_ingress_cidr
  security_group_id = aws_security_group.workload.id
}

resource "aws_security_group_rule" "workload_in_app_sgs" {
  count                    = length(var.workload_ingress_sgs) > 0 ? length(var.workload_ingress_sgs) : 0
  type                     = "ingress"
  from_port                = var.wl_port
  to_port                  = var.wl_port
  protocol                 = "tcp"
  source_security_group_id = element(var.workload_ingress_sgs, count.index)
  security_group_id        = aws_security_group.workload.id
}

# Create only if ht on separate port
resource "aws_security_group_rule" "workload_in_ht_sgs" {
  count                    = length(var.workload_ingress_sgs) > 0 && var.wl_port != var.ht_port ? length(var.workload_ingress_sgs) : 0
  type                     = "ingress"
  from_port                = var.ht_port
  to_port                  = var.ht_port
  protocol                 = "tcp"
  source_security_group_id = element(var.workload_ingress_sgs, count.index)
  security_group_id        = aws_security_group.workload.id
}

output "workload_sg" {
  description = "Workload security group"
  value       = aws_security_group.workload.id
}
