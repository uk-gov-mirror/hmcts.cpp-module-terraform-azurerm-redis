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

  # Enable Private Endpoint for Basic/Standard SKUs
  enable_private_endpoint    = var.enable_private_endpoint
  private_endpoint_subnet_id = var.private_endpoint_subnet_id
  private_dns_zone_ids       = var.private_dns_zone_ids

}
