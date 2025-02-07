# resource "aws_redshift_cluster" "redshift_cluster" {
#   cluster_identifier       = var.cluster_name
#   database_name            = var.database_name
#   master_username          = var.redshift_user_database
#   master_password          = var.redshift_password_database
#   node_type                = var.node_type
#   number_of_nodes          = var.number_nodes
#   cluster_type             = var.cluster_type
#   publicly_accessible       = var.publicly_accessible
#   cluster_subnet_group_name = aws_redshift_subnet_group.redshift_subnet_group.name
#   vpc_security_group_ids   = var.security_groups_cluster
#   encrypted                = var.encrypted_cluster

#   iam_roles                = var.iam_roles_cluster

#   tags = {
#     Name = var.cluster_name
#   }
# }


# resource "aws_redshift_subnet_group" "redshift_subnet_group" {
#   name       = var.name_subnet_group
#   subnet_ids = var.subnets_ids_cluster

#   tags = {
#     Name = var.name_subnet_group
#   }
# }

# # IAM Role for Redshift
# resource "aws_iam_role" "redshift_role" {
#   name = "${var.cluster_identifier}-iam-role"

#   assume_role_policy = <<EOF
#   {
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Action": "sts:AssumeRole",
#         "Principal": {
#           "Service": "redshift.amazonaws.com"
#         },
#         "Effect": "Allow",
#         "Sid": ""
#       }
#     ]
#   }
#   EOF
# }

# resource "aws_iam_role_policy_attachment" "redshift_s3_access" {
#   role       = aws_iam_role.redshift_role.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
# }

# # Security Group for Redshift
# resource "aws_security_group" "redshift_sg" {
#   name        = "${var.cluster_identifier}-sg"
#   description = "Allow Redshift access"
#   vpc_id      = var.vpc_id

#   ingress {
#     from_port   = 5439
#     to_port     = 5439
#     protocol    = "tcp"
#     cidr_blocks = var.allowed_cidr_blocks
#   }
# }


# # resource "aws_redshift_subnet_group" "redshift_subnet_group" {
# #   name       = "${var.cluster_identifier}-subnet-group"
# #   subnet_ids = module.vpc.subnet_ids  # Usar las subnets del módulo VPC

# #   tags = {
# #     Name = "${var.cluster_identifier}-subnet-group"
# #   }
# # }
