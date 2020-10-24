variable "asg_min" {
  description = "Minimum number of instances"
  type        = number
  default     = 1
}

variable "asg_desired" {
  description = "Initial number of instances"
  type        = number
  default     = 2
}

variable "asg_max" {
  description = "Maximum number of instances"
  type        = number
  default     = 3
}
