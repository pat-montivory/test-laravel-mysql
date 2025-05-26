# tf/registry.tf
resource "azurerm_container_registry" "main" {
  name                = replace("${var.project}${var.environment}registry", "-", "")
  resource_group_name = azurerm_resource_group.main.name
  location            = "southeastasia"
  sku                 = "Basic"
  admin_enabled       = true

  # Add explicit dependency on resource group
  depends_on = [
    azurerm_resource_group.main
  ]
}

# Add role assignment for Container App to pull images
resource "azurerm_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.container_app.principal_id
}

# Add role assignment for Container App to push images
resource "azurerm_role_assignment" "acr_push" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.container_app.principal_id
}

# Add role assignment for Container App to manage ACR
resource "azurerm_role_assignment" "acr_manage" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.container_app.principal_id
}