
tags = {
  domain      = "cpp.nonlive"
  platform    = "nlv"
  environment = "test"
  tier        = "data"
  project     = "paas"
}
resource_group_name = "rg-lab-cpp-redisterratest"
redis_server_settings = {
  test-redis = {
    sku_name                      = "Premium"
    capacity                      = 1
    public_network_access_enabled = false
    minimum_tls_version           = 1.2
    enable_non_ssl_port           = false
  }
}

redis_configuration = {
  enable_authentication = true
}

# Premium SKU - Use VNET integration, not Private Endpoints
enable_private_endpoint = false
subnet_id               = null

# These are only needed when enable_private_endpoint = true (Basic/Standard SKU)
private_endpoint_subnet_id          = null
virtual_network_name                = null
virtual_network_resource_group_name = null
