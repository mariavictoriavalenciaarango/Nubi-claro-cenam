output "role_name" {
  description = "El nombre del IAM Role creado"
  value       = aws_iam_role.redshift-serverless-role.name
}