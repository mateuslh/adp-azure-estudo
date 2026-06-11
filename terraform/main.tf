# RG já existe e é compartilhado — apenas referenciado, não gerenciado pelo Terraform
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

# Flexible Server é o tier atual recomendado pela Azure (Single Server está sendo descontinuado).
# SKU Standard_B1ms: burstable, 1 vCore, 2 GB RAM — o menor e mais barato disponível.
resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "psql-adp-estudo"
  resource_group_name    = data.azurerm_resource_group.main.name
  location               = data.azurerm_resource_group.main.location
  version                = "16"
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password

  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768 # 32 GB — mínimo permitido

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  # Acesso público controlado por firewall rules abaixo
  public_network_access_enabled = true

  tags = var.tags

  # A Azure atribui zone automaticamente — ignorar para evitar drift
  lifecycle {
    ignore_changes = [zone]
  }
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Libera acesso somente para os serviços Azure (útil para pipelines e Azure services)
resource "azurerm_postgresql_flexible_server_firewall_rule" "azure_services" {
  name             = "allow-azure-services"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
