variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  type        = string
}

variable "public_subnet_id" {
  description = "Public Subnet ID"
  type        = string
}

variable "private_subnet_id" {
  description = "Private Subnet ID"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}