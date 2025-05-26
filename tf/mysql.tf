resource "azurerm_mysql_flexible_server" "main" {
  name                = "${var.project}-${var.environment}-mysql"
  location            = "southeastasia"
  resource_group_name = azurerm_resource_group.main.name

  sku_name = "B_Standard_B1ms"

  storage {
    size_gb = 20
  }

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false

  administrator_login    = var.mysql_admin_username
  administrator_password = var.mysql_admin_password
  version               = "8.0.21"
}

# For MySQL Flexible Server, we don't need a separate database resource
# The database will be created by the application

# Allow all IP addresses for testing
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_all" {
  name                = "allow-all-ips"
  resource_group_name = azurerm_resource_group.main.name
  server_name         = azurerm_mysql_flexible_server.main.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}