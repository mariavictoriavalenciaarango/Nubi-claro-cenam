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

variable "endpoint" {}
variable "port" {}
variable "master_username" {}
variable "master_password" {}
variable "database_name" {}
