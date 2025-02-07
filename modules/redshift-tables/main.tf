resource "null_resource" "redshift_table" {
  for_each = { for table in var.tables : table.create_table => table }

  # Step 1: Create Table
provisioner "local-exec" {
  command = <<EOT
    cmd /C "set PGPASSWORD=${var.master_password} && psql -h ${var.endpoint} -p ${var.port} -U ${var.master_username} -d ${var.database_name} -c \"${each.value.create_table}\""
  EOT
}
}
