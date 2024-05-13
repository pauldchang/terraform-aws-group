# variable "public_subnet_cidrs" {
#  type        = list(string)
#  description = "Public Subnet CIDR values"
#  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
# }
 
# variable "private_subnet_cidrs" {
#  type        = list(string)
#  description = "Private Subnet CIDR values"
#  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
# }
variable "db_name" {
  description = "wordpress-db"
  type        = string
}

variable "db_user" {
  description = "admin"
  type        = string
}

variable "db_password" {
  description = "password"
  type        = string
}

# variable "db_host" {
#   description = "WordPress database host"
#   type        = string
# }

variable "db_username" {
  description = "admin"
  type        = string
}

variable "db_password" {
  description = "password"
  type        = string
}
