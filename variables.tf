variable "function_app_name" {
  type        = string
  description = "Name of the Flex Consumption Function App"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "app_service_plan_id" {
  type        = string
  description = "ID of existing Flex Consumption App Service Plan (FC1)"
}

variable "storage_account_name" {
  type        = string
  description = "Existing Storage Account name"
}

variable "storage_container_name" {
  type        = string
  description = "Blob container name for Flex Function App"
}

variable "runtime_stack" {
  type        = string
  description = "Runtime stack (node | python | dotnet | java)"
}

variable "runtime_version" {
  type        = string
  description = "Runtime version"
}

variable "max_instance_count" {
  type        = number
  description = "Maximum number of instances"
}

variable "instance_memory_in_mb" {
  type        = number
  description = "Memory per instance in MB"
}

variable "https_only" {
  type        = bool
  description = "Enforce HTTPS only"
}

variable "app_command_line" {
  type        = string
  description = "Optional app command line"
  default     = ""
}

variable "vnet_route_all_enabled" {
  type        = bool
  description = "Route all outbound traffic into VNet"
  default     = false
}
variable "virtual_network_subnet_id" {
  type        = string
  description = "vnet_subentid"
}

variable "public_network_access_enabled" {
  type        = string
  default     = false
  description = "to enable public access"
}
# App Settings
# variable "app_settings" {
#   type        = map(string)
#   default     = {
#     FUNCTIONS_WORKER_RUNTIME = "node"
#     WEBSITE_RUN_FROM_PACKAGE = "1"
#   }
# }
