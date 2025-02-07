# resource "null_resource" "load_data" {
#   for_each = { for table in var.tables-load : table.copy_command => table }

#   provisioner "local-exec" {
#     command = <<EOT
#       PGPASSWORD=${var.master_password} psql \
#       -h ${var.endpoint} \
#       -p ${var.port} \
#       -U ${var.master_username} \
#       -d ${var.database_name} \
#       -c "${each.value.copy_command}"
#     EOT
#   }
# }