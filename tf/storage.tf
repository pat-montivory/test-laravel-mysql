# tf/storage.tf
resource "azurerm_storage_account" "main" {
  name                     = replace("${var.project}${var.environment}storage", "-", "")
  resource_group_name      = azurerm_resource_group.main.name
  location                 = "southeastasia"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version         = "TLS1_2"

  # Add explicit dependency on resource group
  depends_on = [
    azurerm_resource_group.main
  ]

  # Add tags for better resource management
  tags = {
    environment = var.environment
    project     = var.project
  }
}

# Storage containers
resource "azurerm_storage_container" "uploads" {
  name                  = "uploads"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "backups" {
  name                  = "backups"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}