variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# variable "name" {
#   description = "Name of the security group"
#   type        = string
# }

variable "env" {
  description = "Environment name"
  type        = string
}

variable "ingress_rules" {
  description = "List of ingress rules to apply to the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_rules" {
  description = "List of egress rules to apply to the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "instance_name" {
  description = "Name of the instance associated with this security group"
  type        = string
  default     = "unknown-instance"
}