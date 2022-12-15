terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "=3.0.0"
      }
    }
}

provider "azurerm" {
  features {}
}

locals {
  notification_hub_name = "customer-notifications"
  notification_hub_namespace = "notification-hub-device-notifications-namespace"
}

resource "azurerm_resource_group" "nh_resource_group" {
  name     = "notification-hub-demo-rg"
  location = "East US 2"
}
# notification hub
module "notification_hub" {
  source = "./modules/notification-hub"
  location = azurerm_resource_group.nh_resource_group.location
  resource_group_name = azurerm_resource_group.nh_resource_group.name
  nh_namespace_name = local.notification_hub_namespace
  nh_name = local.notification_hub_name
}

module "notification_hub_function_app" {
  source = "./modules/function"
  app_name = "notification-hub-funcs-app"
  resource_group_name = azurerm_resource_group.nh_resource_group.name
  location = azurerm_resource_group.nh_resource_group.location
  storage_account_name = "nhfuncssa" #customer messaging func sa
  host_sku = "Y1"
  app_settings = {
     # set notification hub name as an environment variable for confugration at startup time
    "NOTIFICATION_HUB_NAME" = local.notification_hub_name
    "NOTIFICATION_HUB_CS" = "Endpoint=sb://${local.notification_hub_namespace}.servicebus.windows.net/;SharedAccessKeyName=${module.notification_hub.auth_rule_name};SharedAccessKey=${module.notification_hub.auth_rule_primary_access_key}" #
  }
}
