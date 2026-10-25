resource "azurerm_resource_group" "test_resource_group" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "test_storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.test_resource_group.name
  location                 = azurerm_resource_group.test_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "test_container" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.test_storage_account.id
  container_access_type = "private"
}

resource "time_sleep" "wait_for_container" {
  depends_on      = [azurerm_storage_container.test_container]
  create_duration = "60s"
}

resource "azurerm_storage_blob" "test_blob" {
  name                 = var.blob_name
  storage_container_id = azurerm_storage_container.test_container.id
  type                 = "Block"
  source               = "code.zip"
  depends_on           = [time_sleep.wait_for_container]
}
