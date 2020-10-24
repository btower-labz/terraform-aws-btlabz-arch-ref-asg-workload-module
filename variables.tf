variable "name" {
  default = "workload"
}

variable "subnets" {
}

variable "instance_type" {
  default = "t3.nano"
}

variable "lb_listener_arn" {
  description = "ALB listener ARN to bind all the rules"
  type        = string
}

variable "hostnames" {
  description = "Hostnames to add to rules. Default is *"
  type        = list
  default     = []
}

variable "config_path" {
  description = "Configuration path for SSM and Secrets"
  type        = string
  default     = "/dev"
}

variable "deregistration_delay" {
  description = "The amount time for Elastic Load Balancing to wait before changing the state of a deregistering target from draining to unused."
  type        = number
  default     = 30
}

variable "slow_start" {
  description = "The amount time for targets to warm up before the load balancer sends them a full share of requests."
  type        = number
  default     = 30
}

variable "load_balancing_algorithm_type" {
  description = "Determines how the load balancer selects targets when routing requests."
  type        = string
  default     = "round_robin"
}

variable "wl_port" {
  description = "Workload port."
  type        = number
  default     = 80
}

variable "wl_paths" {
  description = "Workload path prefixes."
  type        = list(string)
  default     = ["/", "/*"]
}

variable "ht_port" {
  description = "Health check port."
  type        = number
  default     = 80
}

variable "ht_path" {
  description = "Health check path."
  type        = string
  default     = "/ht"
}

variable "ht_ok_codes" {
  description = "Good health HTTP response codes."
  type        = list(number)
  default     = [200]
}

variable "ht_interval" {
  description = "Health check interval in seconds."
  type        = number
  default     = 30
}

variable "ht_timeout" {
  description = "Health check timeout in seconds."
  type        = number
  default     = 5
}

variable "tags" {
  description = "Additional tags. E.g. environment, backup tags etc"
  type        = map
  default     = {}
}
