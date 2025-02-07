module "vpc" {
  source                    = "./modules/vpc"
  count                     = var.deploy_vpc ? 1 : 0 # Deploy the module only if true
  vpc_name                  = var.vpc_name
  Environment               = var.Environment
  Project                   = var.Project
  Region                    = var.Region
  vpc_cidr                  = var.vpc_cidr
  ipv6_support              = var.ipv6_support
  availability_zones_to_use = var.availability_zones_to_use
  enable_nat_gateway        = true
}

module "iam_role" {
  source      = "./modules/iam"
  Environment = var.Environment
  app_name    = var.app_name
}

module "redshift_serverless" {
  source = "./modules/redshift_serverless"

  redshift_serverless_namespace_name      = var.redshift_serverless_namespace_name
  redshift_serverless_database_name       = var.redshift_serverless_database_name
  redshift_serverless_admin_username      = var.redshift_serverless_admin_username
  redshift_serverless_admin_password      = var.redshift_serverless_admin_password
  redshift_serverless_workgroup_name      = var.redshift_serverless_workgroup_name
  redshift_serverless_base_capacity       = var.redshift_serverless_base_capacity
  redshift_serverless_publicly_accessible = var.redshift_serverless_publicly_accessible
  Environment                             = var.Environment
  iam_roles                               = [module.iam_role.role_name]
  security_group                          = [module.vpc[0].public_security_group_id]
  subnet                                  = concat(module.vpc[0].public_subnets, module.vpc[0].private_subnets)
  app_name                                = var.app_name

  depends_on = [module.iam_role, module.vpc]
}


# Creación del Clúster Redshift
# data "aws_vpc" "selected" {
#   filter {
#     name   = "tag:Name"
#     values = [var.vpc_name]
#   }
# }

# data "aws_subnets" "default" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.selected.id] # Asegúrate de definir "vpc_id"
#   }
# }

# module "kms-cluster" {
#   source = "./kms"

#   description_kms     = var.description_kms
#   deletion_window_kms = var.deletion_window_kms
#   alias_kms           = var.alias_kms
#   key_rotation        = var.key_rotation

# }


# module "redshift-cluster" {
#   source = "./modules/redshift-cluster"

#   cluster_name               = var.cluster_name
#   database_name              = var.database_name
#   redshift_user_database     = var.redshift_user_database
#   redshift_password_database = var.redshift_password_database
#   node_type                  = var.node_type
#   number_nodes               = var.number_nodes
#   security_groups_cluster    = [module.vpc.security_group]
#   encrypted_cluster          = var.encrypted_cluster
#   cluster_type               = var.cluster_type
#   publicly_accessible        = var.publicly_accessible
#   iam_roles_cluster          = [module.iam_role.role-name]
#   name_subnet_group          = var.name_subnet_group
#   subnets_ids_cluster        = [module.vpc.subnet_1, module.vpc.subnet_2, module.vpc.subnet_3, module.vpc.subnet_4]

# }


# module "redshift_cluster" {
#   source = "./modules/redshift-cluster"

#   cluster_identifier         = var.cluster_identifier
#   cluster_name               = var.cluster_name
#   database_name              = var.database_name
#   redshift_user_database     = var.redshift_user_database
#   redshift_password_database = var.redshift_password_database
#   node_type                  = var.node_type
#   number_nodes               = var.number_nodes
#   cluster_type               = var.cluster_type
#   publicly_accessible        = var.publicly_accessible
#   security_groups_cluster    = var.security_groups_cluster
#   encrypted_cluster          = var.encrypted_cluster
#   kms_arn_cluster            = var.kms_arn_cluster
#   subnets_ids_cluster        = data.aws_subnets.default.ids
#   vpc_id                     = data.aws_vpc.selected.id
#   iam_roles_cluster          = var.iam_roles_cluster
#   allowed_cidr_blocks        = [var.vpc_cidr]

# }

# # Creación del Rol IAM para Lambda
# resource "aws_iam_role" "lambda_role" {
#   name = "lambda_redshift_role"

#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "lambda.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }


# # Permisos para que Lambda acceda a Redshift
# resource "aws_iam_policy" "lambda_redshift_policy" {
#   name        = "LambdaRedshiftPolicy"
#   description = "Permite que Lambda acceda a Redshift y ejecute consultas"
#   policy      = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "redshift:GetClusterCredentials",
#                 "redshift:DescribeClusters"
#             ],
#             "Resource": [
#                 "arn:aws:redshift:us-east-1:015319782619:cluster/mi-cluster-redshift",
#                 "arn:aws:redshift:us-east-1:015319782619:dbuser:mi-cluster-redshift/admin_claro_cenam"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "redshift-data:ExecuteStatement",
#                 "redshift-data:DescribeStatement",
#                 "redshift-data:GetStatementResult"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }


# resource "aws_iam_policy_attachment" "lambda_attach_redshift_policy" {
#   name       = "lambda_attach_redshift_policy"
#   roles      = [aws_iam_role.lambda_role.name]
#   policy_arn = aws_iam_policy.lambda_redshift_policy.arn
# }


# # Creación de logs en Cloudwatch
# resource "aws_iam_policy_attachment" "lambda_basic_execution_policy" {
#   name       = "lambda_basic_execution_policy"
#   roles      = [aws_iam_role.lambda_role.name]
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }


# # Creación de la Lambda en Python
# data "archive_file" "lambda_package" {
#   type        = "zip"
#   source_file = "lambda/lambda_function.py"
#   output_path = "lambda_function.zip"
# }

# resource "aws_lambda_function" "create_table_lambda" {
#   function_name    = "create_table_lambda"
#   runtime          = "python3.9"
#   role             = aws_iam_role.lambda_role.arn
#   handler          = "lambda_function.lambda_handler"
#   filename         = "lambda_function.zip"
#   source_code_hash = data.archive_file.lambda_package.output_base64sha256

#   environment {
#     variables = {
#       REDSHIFT_DATABASE   = var.database_name
#       REDSHIFT_USER       = var.redshift_user_database
#     }
#   }
# }

