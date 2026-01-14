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
}

module "redis" {
  source                = "../"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  redis_server_settings = var.redis_server_settings
  redis_configuration = {
    enable_authentication = lookup(var.redis_configuration, "enable_authentication", true)
  }

  # For Premium SKU: Use direct VNET integration via subnet_id
  # For Basic/Standard SKU: Set subnet_id to null and use Private Endpoints instead
  subnet_id = var.enable_private_endpoint ? null : var.subnet_id

  # Private Endpoint Configuration (for Basic/Standard SKUs)
  enable_private_endpoint             = var.enable_private_endpoint
  private_endpoint_subnet_id          = var.enable_private_endpoint ? var.private_endpoint_subnet_id : null
  virtual_network_name                = var.enable_private_endpoint ? var.virtual_network_name : null
  virtual_network_resource_group_name = var.enable_private_endpoint ? var.virtual_network_resource_group_name : null
}
