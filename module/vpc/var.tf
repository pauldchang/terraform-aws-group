# variable "cidr_block" {
#   type    = string
#   default = "10.0.0.0/16"
# }

# variable "num_public_subnets" {
#   type    = number
#   default = 3
# }

# variable "num_private_subnets" {
#   type    = number
#   default = 3
# }

# variable "internet_gateway_name" {
#   type    = string
#   default = "my-internet-gateway"
# }
variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}