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

variable "iam_roles" {
  type = list(string)
  description = "iam_roles"
}

variable "Environment" {
  type        = string
  description = "The environment (e.g., dev, prod)"
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

variable "security_group" {
  type = list(string)
  description = "data"
}

variable "subnet" {
  type = list(string)
  description = "subnets"
}

variable "redshift_serverless_publicly_accessible" {
  type        = bool
  description = "Set the Redshift Serverless to be Publicly Accessible"
  default     = false
}

variable "app_name" {
  type        = string
  description = "Application name"
}