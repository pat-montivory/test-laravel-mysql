output "container_app_url" {
  value = "https://${azurerm_container_app.main.ingress[0].fqdn}"
}

output "mysql_server_fqdn" {
  value = azurerm_mysql_flexible_server.main.fqdn
}

output "mysql_database_name" {
  value = "laravel"
  description = "The name of the Laravel database"
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "container_registry_login_server" {
  value = azurerm_container_registry.main.login_server
}