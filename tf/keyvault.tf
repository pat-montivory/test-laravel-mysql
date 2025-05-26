# tf/keyvault.tf
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = "${var.project}-${var.environment}-kv"
  location            = "southeastasia"
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  purge_protection_enabled = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge",
      "Recover",
      "Backup",
      "Restore"
    ]
  }

  depends_on = [
    azurerm_resource_group.main
  ]
}

# Store secrets in Key Vault
resource "azurerm_key_vault_secret" "db_host" {
  name         = "DB-HOST"
  value        = azurerm_mysql_flexible_server.main.fqdn
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_database" {
  name         = "db-database"
  value        = "laravel"
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_username" {
  name         = "DB-USERNAME"
  value        = var.mysql_admin_username
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "DB-PASSWORD"
  value        = var.mysql_admin_password
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "storage_key" {
  name         = "AZURE-STORAGE-KEY"
  value        = azurerm_storage_account.main.primary_access_key
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "storage_account" {
  name         = "AZURE-STORAGE-ACCOUNT"
  value        = azurerm_storage_account.main.name
  key_vault_id = azurerm_key_vault.main.id
}