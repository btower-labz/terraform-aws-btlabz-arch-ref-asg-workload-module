variable "subnets" {
  description = "VPC subnets for workload"
  type        = list(string)
}

locals {
  subnets = sort(distinct(compact(var.subnets)))
}

data "aws_subnet" "main" {
  count = length(local.subnets)
  id    = element(local.subnets, count.index)
}

data "aws_vpc" "main" {
  id = data.aws_subnet.main[0].vpc_id
}
