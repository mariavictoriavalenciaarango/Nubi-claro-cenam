
#########################
## Network - Variables ##
#########################

# Network configuration

variable "ipv6_support" {
  description = "Enable IPv6"
  type        = bool
  default     = true
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  # default     = "10.0.0.0/16"
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

variable "deploy_vpc" {
  type        = bool
  description = "deploy_vpc"
}

#########################
## General - Variables ##
#########################

variable "Project" {
  description = "Nombre del proyecto"
  type        = string
}

variable "Environment" {
  type        = string
  description = "The environment (e.g., dev, prod)"
}

variable "Region" {
  description = "AWS region to deploy the VPC"
  type        = string
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "Team" {
  description = "Team"
  type        = string
}

variable "owner" {
  description = "owner"
  type        = string
}

variable "createdBy" {
  description = "createdBy"
  type        = string
}

variable "deadline" {
  description = "deadline"
  type        = string
}


# Redshift Serverless
variable "redshift_serverless_namespace_name" {
  type        = string
  description = "Redshift Serverless Namespace Name"
}

variable "redshift_serverless_database_name" {
  type        = string
  description = "Redshift Serverless Database Name"
}

variable "redshift_serverless_admin_username" {
  type        = string
  description = "Redshift Serverless Admin Username"
}

variable "redshift_serverless_admin_password" {
  type        = string
  description = "Redshift Serverless Admin Password"
}

variable "redshift_serverless_workgroup_name" {
  type        = string
  description = "Redshift Serverless Workgroup Name"
}

variable "redshift_serverless_base_capacity" {
  type        = number
  description = "Redshift Serverless Base Capacity"
  default     = 32 // 32 RPUs to 512 RPUs in units of 8 (32,40,48...512)
}

variable "redshift_serverless_publicly_accessible" {
  type        = bool
  description = "Set the Redshift Serverless to be Publicly Accessible"
  default     = false
}

variable "cluster_name" {
  type        = string
  description = "cluster_name"
}

variable "database_name" {
  type        = string
  description = "database_name"
}

variable "redshift_user_database" {
  type        = string
  description = "redshift_user_database"
}

variable "redshift_password_database" {
  type        = string
  description = "redshift_password_database"
}

variable "node_type" {
  type        = string
  description = "node_type"
}

variable "number_nodes" {
  type        = number
  description = "number_nodes"
}

variable "cluster_type" {
  type        = string
  description = "cluster_type"
}

variable "publicly_accessible" {
  type        = bool
  description = "publicly_accessible"
}

variable "encrypted_cluster" {
  type        = bool
  description = "encrypted_cluste"
}

variable "tables" {
  description = "List of SQL statements to create tables"
  type        = list(map(string))
  default     = []
}

variable "tables-load" {
  description = "List of SQL statements to create tables"
  type        = list(map(string))
  default     = []
}

variable "app_name" {
  type        = string
  description = "Application name"
}

variable "name_subnet_group" {
  type        = string
  description = "name_subnet_group"
}

variable "security_groups_cluster" {
  type        = list(string)
  description = "security_groups_cluster"
  default     = []
}

# variable "kms_arn_cluster" {
#   type        = string
#   description = "kms_arn_cluster"
# }

variable "iam_roles_cluster" {
  type        = list(string)
  description = "iam_roles_cluster"
  default     = []
}

# variable "subnets_ids_cluster" {
#   type        = list(string)
#   description = "subnets_ids_cluster"
# }

# variable "subnet" {
#   type        = string
#   description = "Lista de subnets a ser utilizadas"
# }