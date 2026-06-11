output "server_name" {
  description = "Nome do servidor PostgreSQL"
  value       = azurerm_postgresql_flexible_server.main.name
}

output "server_fqdn" {
  description = "FQDN do servidor para conexão"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "database_name" {
  description = "Nome do banco de dados criado"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

output "connection_string" {
  description = "String de conexão PostgreSQL (sem senha)"
  value       = "postgresql://${var.db_admin_username}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/${var.db_name}?sslmode=require"
  sensitive   = false
}

output "resource_group_name" {
  description = "Nome do resource group criado"
  value       = azurerm_resource_group.main.name
}
