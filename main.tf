# Existing Storage Account
data "azurerm_storage_account" "func_sa" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_function_app_flex_consumption" "this" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = var.app_service_plan_id

  #   # Storage
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${data.azurerm_storage_account.func_sa.primary_blob_endpoint}${var.storage_account_name}-container"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = data.azurerm_storage_account.func_sa.primary_access_key

  # Runtime
  runtime_name    = var.runtime_stack
  runtime_version = var.runtime_version

  # Scaling & memory
  maximum_instance_count = var.max_instance_count
  instance_memory_in_mb  = var.instance_memory_in_mb

  https_only                    = var.https_only
  virtual_network_subnet_id     = var.virtual_network_subnet_id
  public_network_access_enabled = var.public_network_access_enabled

  site_config {
    app_command_line       = var.app_command_line
    vnet_route_all_enabled = var.vnet_route_all_enabled
  }
  
    depends_on = [
    azurerm_service_plan.function_plan
  ]

  lifecycle {
    ignore_changes = [
      app_settings,
      site_config,
      sticky_settings,
      tags,
      storage_container_endpoint
    ]
  }
}