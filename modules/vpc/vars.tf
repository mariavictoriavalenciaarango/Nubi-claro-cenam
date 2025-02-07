variable "Environment" {
  type        = string
  description = "Application environment"
}

variable "Region" {
  type = string
  description = "aws_region"  
}

variable "Project" {
  description = "Nombre del proyecto"
  type        = string
}

#########################
## Network - Variables ##
#########################

variable "vpc_name" {
  description = "Nombre de la VPC"
  type        = string
}

variable "ipv6_support" {
  description = "Enable IPv6"
  type        = bool
  default = true  
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones_to_use" {
  description = "Number of availability zones to use"
  type        = number
}

variable "enable_nat_gateway" {
  description = "Whether to create NAT Gateway"
  type        = bool
  default     = true
}
