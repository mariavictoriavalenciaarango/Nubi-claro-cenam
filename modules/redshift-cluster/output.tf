# output "redshift_cluster_endpoint" {
#   description = "Endpoint del clúster de Redshift"
#   value       = aws_redshift_cluster.redshift_cluster.endpoint
# }

# output "redshift_cluster_id" {
#   description = "ID del clúster de Redshift"
#   value       = aws_redshift_cluster.redshift_cluster.id
# }

# output "redshift_iam_role_arn" {
#   description = "ARN del IAM Role asociado al clúster"
#   value       = aws_iam_role.redshift_role.arn
# }

# output "subnet_ids" {
#   value = data.aws_subnets.default.ids
# }

# output "subnet_ids" {
#   value = [
#     aws_subnet.subnet_1.id,
#     aws_subnet.subnet_2.id,
#     aws_subnet.subnet_3.id
#   ]
# }
