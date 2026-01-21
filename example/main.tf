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

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = module.tag_set.tags

  lifecycle {
    ignore_changes = [tags]
  }
}

module "redis" {
  source              = "../"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  redis_server_settings = {
    for key, value in var.redis_server_settings :
    var.name_suffix != "" ? "${key}-${var.name_suffix}" : key => value
  }
  redis_configuration = {
    authentication_enabled = lookup(var.redis_configuration, "authentication_enabled", true)
  }
}
