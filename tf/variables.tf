variable "location" {
  description = "Azure region"
  type        = string
  default     = "southeastasia"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "laravel-app"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "mysql_admin_username" {
  description = "MySQL admin username"
  type        = string
  default     = "mysqladmin"
}

variable "mysql_admin_password" {
  description = "MySQL admin password"
  type        = string
  sensitive   = true
}
