output "redis_cache_instance_id" {
  description = "The Route ID of Redis Cache Instance"
  value       = module.redis.redis_cache_instance_id
}

output "redis_cache_hostname" {
  description = "The Hostname of the Redis Instance"
  value       = module.redis.redis_cache_hostname
}

output "redis_cache_ssl_port" {
  description = "The SSL Port of the Redis Instance"
  value       = module.redis.redis_cache_ssl_port
}
