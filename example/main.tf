module "tag_set" {
  source         = "git::https://github.com/hmcts/cpp-module-terraform-azurerm-tag-generator.git?ref=main"
  namespace      = var.namespace
  application    = var.application
  costcode       = var.costcode
  owner          = var.owner
  version_number = var.version_number
  attribute      = var.attribute
  environment    = var.environment
  type           = var.type
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}

locals {
  redis_server_settings = {
    for key, value in var.redis_server_settings :
    "${key}-${random_string.suffix.result}" => value
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = module.tag_set.tags
}

module "redis" {
  source                = "../"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  redis_server_settings = local.redis_server_settings
  redis_configuration = {
    authentication_enabled = lookup(var.redis_configuration, "authentication_enabled", true)
  }
}
