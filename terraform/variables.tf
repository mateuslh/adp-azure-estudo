variable "subscription_id" {
  description = "ID da subscription Azure"
  type        = string
}

variable "location" {
  description = "Região Azure"
  type        = string
  default     = "brazilsouth"
}

variable "resource_group_name" {
  description = "Nome do resource group"
  type        = string
  default     = "rg-adp-postgres-test"
}

variable "db_admin_username" {
  description = "Usuário administrador do PostgreSQL"
  type        = string
  default     = "pgadmin"
}

variable "db_admin_password" {
  description = "Senha do administrador do PostgreSQL"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "adp_test"
}

variable "tags" {
  description = "Tags aplicadas em todos os recursos"
  type        = map(string)
  default = {
    environment = "test"
    project     = "adp-azure-estudo"
    managed_by  = "terraform"
  }
}
