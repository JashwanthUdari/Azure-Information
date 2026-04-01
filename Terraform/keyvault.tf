resource "azurerm_key_vault" "Keyvault" {
  name                        = "keyvault-0001"
  location                    = local.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days = 7
  
}