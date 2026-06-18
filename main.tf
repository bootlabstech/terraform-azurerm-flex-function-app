resource "azurerm_service_plan" "example" {
  name                = "${var.function_app_name}-flexasp"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.asp_sku
  os_type             = var.asp_os_type
}

# Existing Storage Account
data "azurerm_storage_account" "func_sa" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_function_app_flex_consumption" "this" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location
  service_plan_id     = azurerm_service_plan.example.id

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
    azurerm_service_plan.example
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

# Private endpoint block stays same
resource "azurerm_private_endpoint" "endpoint" {
  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name}-connection"
    private_connection_resource_id = azurerm_function_app_flex_consumption.this.id
    is_manual_connection           = var.is_manual_connection
    subresource_names              = var.subresource_names
  }

  private_dns_zone_group {
    name                 = "${var.function_app_name}-dnszone"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

