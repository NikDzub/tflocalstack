variable "project_name" {
  type = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
  default     = "10.0.0.0/16"
}
##############################################
variable "az_count" {
  description = "Number of Availability Zones for subnets"
  type        = number
  default     = 2
}
variable "pub_sub_per_az_count" {
  description = "Number of public subnets per az."
  type        = number
  default     = 1
}
variable "priv_sub_per_az_count" {
  description = "Number of private subnets."
  type        = number
  default     = 2
}
##############################################
variable "pub_sub_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
  ]
}
variable "priv_sub_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24",
    "10.0.14.0/24",
    "10.0.15.0/24",
    "10.0.16.0/24",
    "10.0.17.0/24",
    "10.0.18.0/24",
  ]
}
##############################################


