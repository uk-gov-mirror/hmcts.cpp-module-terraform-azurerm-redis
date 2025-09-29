
resource "vault_generic_secret" "redis_cache_access_keys" {
  for_each   = var.redis_server_settings
  depends_on = [azurerm_redis_cache.main]
  path       = format("secret/terraform/%s/rediscache/%s", var.environment, each.key)
  data_json  = <<EOT
{
  "primary_access_key": "${lookup(lookup(azurerm_redis_cache.main, each.key), "primary_access_key")}",
  "secondary_access_key": "${lookup(lookup(azurerm_redis_cache.main, each.key), "secondary_access_key")}"
}
EOT

}
