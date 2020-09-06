variable "ami" {
  description = "Workload AMI identifier"
  type        = string
  default     = ""
}

data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*.0-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["656109587541"] # Canonical
}

locals {
  ami = "${var.ami == "" ? data.aws_ami.amzn2.id : var.ami}"
}

output "latest_ami" {
  description = "The latest AMI"
  value       = "${local.ami}"
}
