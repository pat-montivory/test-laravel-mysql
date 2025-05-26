# tf/container_apps.tf
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project}-${var.environment}-law"
  location            = "southeastasia"
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "main" {
  name                = "${var.project}-${var.environment}-env"
  location            = "southeastasia"
  resource_group_name = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
}

resource "azurerm_user_assigned_identity" "container_app" {
  name                = "${var.project}-${var.environment}-identity"
  resource_group_name = azurerm_resource_group.main.name
  location            = "southeastasia"
}

resource "azurerm_container_app" "main" {
  name                = "${var.project}-${var.environment}-app"
  resource_group_name = azurerm_resource_group.main.name
  container_app_environment_id = azurerm_container_app_environment.main.id
  revision_mode       = "Single"

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container_app.id]
  }

  registry {
    server   = azurerm_container_registry.main.login_server
    identity = azurerm_user_assigned_identity.container_app.id
  }

  ingress {
    external_enabled = true
    target_port     = 80
    transport       = "http"

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    container {
      name   = "laravel"
      image  = "${azurerm_container_registry.main.login_server}/laravel:latest"
      cpu    = 0.5
      memory = "1Gi"
    }
  }
}