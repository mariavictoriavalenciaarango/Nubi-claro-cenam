##########################
# VPC # 
##########################
Region      = "us-east-1"
Environment = "dev" # Dev, Test, Staging, Prod, etc
vpc_name    = "claro"
Project     = "claro-cenam"
vpc_cidr    = "10.0.0.0/16"

deploy_vpc                = true
availability_zones_to_use = 4

Team      = "POD-7"
owner     = "victoria.valencia@nubiral.com"
createdBy = "Victoria Valencia"
deadline  = "2025-03-15" # Preguntar la fecha

##########################
# Redshift serverless # 
##########################

redshift_serverless_namespace_name      = "kopicloud-namespace"
redshift_serverless_database_name       = "kopiclouddb"
redshift_serverless_admin_username      = "kopiadmin"
redshift_serverless_admin_password      = "M3ss1G0at10"
redshift_serverless_workgroup_name      = "kopicloud-workgroup"
redshift_serverless_base_capacity       = 32 // 32 RPUs to 512 RPUs in units of 8 (32,40,48...512)
redshift_serverless_publicly_accessible = false
app_name                                = "kopicloud"

###################################
## Redshift Cluster ###############
###################################

cluster_name               = "claro-cenam-redshift-cluster"
database_name              = "claro_cenam_redshift_db"
redshift_user_database     = "admin_claro_cenam"
redshift_password_database = "1DM3n_Cl1r4_c2n1m"
node_type                  = "ra3.large"
number_nodes               = 2
cluster_type               = "single-node"
publicly_accessible        = false
encrypted_cluster          = true
name_subnet_group          = "redshift-subnet-group-cluster"



# iam_roles                               = [module.iam_role.role-name]
# security_group                          = [module.vpc.security_group]
# subnet = [module.vpc.subnet_1, module.vpc.subnet_2, module.vpc.subnet_3]
# iam_roles_cluster = [module.iam_role.role-name]

##################################
##            TABLES            ##
##################################

# tables = [
#   {
#     create_table = "CREATE TABLE public.users (user_id VARCHAR(40), age INTEGER, registration_date DATE, purchases INTEGER, average_order_value REAL, customer_segment VARCHAR(30));"
#   }
# ]

# tables-load = [
#   {
#     copy_command = <<EOT
#         COPY users
#         FROM 's3://databricksclaro/'
#         IAM_ROLE 'arn:aws:iam::015319782619:role/AmazonMWAA-workshop-redshift-role'
#         Parquet
#         IGNOREHEADER 1;
#       EOT
#   }
# ]
