variable "vpc_name" {
  type        = string
  default     = "vpc_daniel_iac_clc11"
  description = "VPC da network"
}

variable "subnet_public_1a" {
  type        = string
  default     = "iac-public-subnet-1a"
  description = "Subnet public 1a"
}

variable "subnet_public_1c" {
  type        = string
  default     = "iac-public-subnet-1c"
  description = "Subnet public 1c"
}

variable "subnet_private_1a" {
  type        = string
  default     = "iac-private-subnet-1a"
  description = "Subnet private 1a"
}

variable "subnet_private_1c" {
  type        = string
  default     = "iac-private-subnet-1c"
  description = "Subnet private 1c"
}