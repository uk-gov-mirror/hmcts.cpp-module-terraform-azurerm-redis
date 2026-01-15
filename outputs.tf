output "redis_cache_instance_id" {
  description = "The Route ID of Redis Cache Instance"
  value       = element(concat([for n in azurerm_redis_cache.main : n.id], [""]), 0)
}

output "redis_cache_hostname" {
  description = "The Hostname of the Redis Instance"
  value       = element(concat([for h in azurerm_redis_cache.main : h.hostname], [""]), 0)
}

output "redis_cache_ssl_port" {
  description = "The SSL Port of the Redis Instance"
  value       = element(concat([for p in azurerm_redis_cache.main : p.ssl_port], [""]), 0)
}

output "redis_cache_port" {
  description = "The non-SSL Port of the Redis Instance"
  value       = element(concat([for p in azurerm_redis_cache.main : p.port if p == true], [""]), 0)
  sensitive   = true
}

output "redis_cache_primary_access_key" {
  description = "The Primary Access Key for the Redis Instance"
  value       = element(concat([for a in azurerm_redis_cache.main : a.primary_access_key], [""]), 0)
  sensitive   = true
}

output "redis_cache_secondary_access_key" {
  description = "The Secondary Access Key for the Redis Instance"
  value       = element(concat([for a in azurerm_redis_cache.main : a.secondary_access_key], [""]), 0)
  sensitive   = true
}

output "redis_cache_primary_connection_string" {
  description = "The primary connection string of the Redis Instance."
  value       = element(concat([for c in azurerm_redis_cache.main : c.primary_connection_string], [""]), 0)
  sensitive   = true
}

output "redis_cache_secondary_connection_string" {
  description = "The secondary connection string of the Redis Instance."
  value       = element(concat([for a in azurerm_redis_cache.main : a.secondary_connection_string], [""]), 0)
  sensitive   = true
}

output "redis_configuration_maxclients" {
  description = "Returns the max number of connected clients at the same time."
  value       = element(concat([for m in azurerm_redis_cache.main : m.redis_configuration.0.maxclients], [""]), 0)
}

output "private_endpoint_ids" {
  description = "Map of Private Endpoint IDs for Redis Cache instances (Basic/Standard SKUs only)"
  value       = { for k, v in azurerm_private_endpoint.redis : k => v.id }
}

output "private_endpoint_private_ip_addresses" {
  description = "Map of Private IP addresses assigned to Private Endpoints"
  value       = { for k, v in azurerm_private_endpoint.redis : k => v.private_service_connection[0].private_ip_address }
}
