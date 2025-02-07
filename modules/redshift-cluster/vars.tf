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

variable "security_groups_cluster" {
  type = list(string)
  description = "security_groups_cluster"
}

variable "encrypted_cluster" {
  type = bool
  description = "encrypted_cluste"
}

# variable "kms_arn_cluster" {
#   type = string
#   description = "kms_arn_cluster"
# }

variable "iam_roles_cluster" {
  type = list(string)
  description = "iam_roles_cluster"
}

variable "name_subnet_group" {
  type        = string
  description = "name_subnet_group"
}

variable "subnets_ids_cluster" {
  type = list(string)
  description = "subnets_ids_cluster"
  default = []
}

# variable "cluster_identifier" {
#   description = "Nombre único del clúster de Redshift"
#   type        = string
# }

# variable "vpc_id" {
#   description = "ID de la VPC donde se desplegará Redshift"
#   type        = string
# }

# variable "allowed_cidr_blocks" {
#   description = "Lista de CIDRs permitidos para acceder a Redshift"
#   type        = list(string)
# }