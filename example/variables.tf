
variable "location" {
  type    = string
  default = "uksouth"
}

variable "tags" {
  type = map(any)
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "redis_server_settings" {
  type = map(object({
    capacity                      = number
    sku_name                      = string
    enable_non_ssl_port           = optional(bool)
    minimum_tls_version           = optional(string)
    public_network_access_enabled = optional(string)
  }))
  description = "optional redis server setttings for both Premium and Standard/Basic SKU"
  default     = {}
}

variable "redis_family" {
  type        = map(any)
  description = "The SKU family/pricing group to use. Valid values are `C` (for `Basic/Standard` SKU family) and `P` (for `Premium`)"
  default = {
    Basic    = "C"
    Standard = "C"
    Premium  = "P"
  }
}

variable "redis_configuration" {
  type = object({
    enable_authentication = optional(bool)

  })
  description = "Configuration for the Redis instance"
  default     = {}
}


variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be an organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "costcode" {
  type        = string
  description = "Name of theDWP PRJ number (obtained from the project portfolio in TechNow)"
  default     = ""
}

variable "owner" {
  type        = string
  description = "Name of the project or sqaud within the PDU which manages the resource. May be a persons name or email also"
  default     = ""
}


variable "application" {
  type        = string
  description = "Application to which the s3 bucket relates"
  default     = ""
}

variable "attribute" {
  type        = string
  description = "An attribute of the s3 bucket that makes it unique"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment into which resource is deployed"
  default     = ""
}

variable "type" {
  type        = string
  description = "Name of service type"
  default     = ""
}

variable "version_number" {
  type        = string
  description = "The version of the application or object being deployed. This could be a build object or other artefact which is appended by a CI/Cd platform as part of a process of standing up an environment"
  default     = ""
}

variable "enable_private_endpoint" {
  description = "Enable Private Endpoint for Redis Cache. Recommended for Basic/Standard SKUs."
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "The ID of the Subnet where the Private Endpoint will be created."
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "List of Private DNS Zone IDs for Private Endpoint."
  type        = list(string)
  default     = []
}
