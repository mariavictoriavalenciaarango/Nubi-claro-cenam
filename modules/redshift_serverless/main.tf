##############################################
## Create the Redshift Serverless Namespace ##
##############################################

resource "aws_redshiftserverless_namespace" "serverless" {
  namespace_name      = var.redshift_serverless_namespace_name
  db_name             = var.redshift_serverless_database_name
  admin_username      = var.redshift_serverless_admin_username
  admin_user_password = var.redshift_serverless_admin_password
  iam_roles           = [aws_iam_role.redshift-serverless-role.arn]

  tags = {
    Name        = var.redshift_serverless_namespace_name
    Environment = var.Environment
  }
}


##############################################
## Create the Redshift Serverless Workgroup ##
##############################################

resource "aws_redshiftserverless_workgroup" "serverless" {
  depends_on = [aws_redshiftserverless_namespace.serverless]

  namespace_name = aws_redshiftserverless_namespace.serverless.id
  workgroup_name = var.redshift_serverless_workgroup_name
  base_capacity  = var.redshift_serverless_base_capacity
  
  security_group_ids = var.security_group
  subnet_ids         = var.subnet
  publicly_accessible = var.redshift_serverless_publicly_accessible
  
  tags = {
    Name        = var.redshift_serverless_workgroup_name
    Environment = var.Environment
  }
}


resource "aws_iam_role" "redshift-serverless-role" {
  name = "${var.app_name}-${var.Environment}-redshift-serverless-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "redshift.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
