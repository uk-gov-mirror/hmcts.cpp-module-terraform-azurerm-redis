# Storage Account to keep logs and backups - Default is "false"
resource "random_string" "str" {
  count   = var.enable_data_persistence ? 1 : 0
  length  = 6
  special = false
  upper   = false
  keepers = {
    name = var.storage_account_name
  }
}

resource "azurerm_storage_account" "storeacc" {
  #  for_each                  = var.redis_configuration != {} ? { for rdb_backup_enabled, v in var.redis_configuration : rdb_backup_enabled => v if v == true } : null
  count                     = var.enable_data_persistence ? 1 : 0
  name                      = var.storage_account_name == null ? "rediscachebkpstore${random_string.str.0.result}" : substr(var.storage_account_name, 0, 24)
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_kind              = "StorageV2"
  account_tier              = "Standard"
  account_replication_type  = "GRS"
  enable_https_traffic_only = true
  min_tls_version           = "TLS1_2"
  tags                      = merge({ "Name" = format("%s", "stsqlauditlogs") }, var.tags, )
}

# Redis Cache Instance configuration
resource "azurerm_redis_cache" "main" {
  for_each                      = var.redis_server_settings
  name                          = format("%s", each.key)
  resource_group_name           = var.resource_group_name
  location                      = var.location
  capacity                      = each.value["capacity"]
  family                        = lookup(var.redis_family, each.value.sku_name)
  sku_name                      = each.value["sku_name"]
  enable_non_ssl_port           = each.value["enable_non_ssl_port"]
  minimum_tls_version           = each.value["minimum_tls_version"]
  private_static_ip_address     = each.value["private_static_ip_address"]
  public_network_access_enabled = each.value["public_network_access_enabled"]
  replicas_per_master           = each.value["sku_name"] == "Premium" ? each.value["replicas_per_master"] : null
  shard_count                   = each.value["sku_name"] == "Premium" ? each.value["shard_count"] : null
  subnet_id                     = each.value["sku_name"] == "Premium" ? var.subnet_id : null
  zones                         = each.value["zones"]
  tags                          = merge({ "Name" = format("%s", each.key) }, var.tags, )

  redis_configuration {
    #  aof_backup_enabled              = var.enable_aof_backup
    #  aof_storage_connection_string_0 = var.enable_aof_backup == true ? azurerm_storage_account.storeacc.0.primary_blob_connection_string : null
    #  aof_storage_connection_string_1 = var.enable_aof_backup == true ? azurerm_storage_account.storeacc.0.secondary_blob_connection_string : null
    enable_authentication           = lookup(var.redis_configuration, "enable_authentication", true)
    maxfragmentationmemory_reserved = each.value["sku_name"] == "Premium" || each.value["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxfragmentationmemory_reserved") : null
    maxmemory_delta                 = each.value["sku_name"] == "Premium" || each.value["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxmemory_delta") : null
    maxmemory_policy                = lookup(var.redis_configuration, "maxmemory_policy")
    maxmemory_reserved              = each.value["sku_name"] == "Premium" || each.value["sku_name"] == "Standard" ? lookup(var.redis_configuration, "maxmemory_reserved") : null
    notify_keyspace_events          = lookup(var.redis_configuration, "notify_keyspace_events")
    rdb_backup_enabled              = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? true : false
    rdb_backup_frequency            = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? var.data_persistence_backup_frequency : null
    rdb_backup_max_snapshot_count   = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? var.data_persistence_backup_max_snapshot_count : null
    rdb_storage_connection_string   = each.value["sku_name"] == "Premium" && var.enable_data_persistence == true ? azurerm_storage_account.storeacc.0.primary_blob_connection_string : null
  }


  dynamic "patch_schedule" {
    for_each = var.patch_schedule != null ? [var.patch_schedule] : []
    content {
      day_of_week    = var.patch_schedule.day_of_week
      start_hour_utc = var.patch_schedule.start_hour_utc
    }
  }

  lifecycle {
    # A bug in the Redis API where the original storage connection string isn't being returneds
    ignore_changes = [redis_configuration.0.rdb_storage_connection_string]
  }

}
