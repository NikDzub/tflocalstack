# VPC
variable "project_name" {
  type    = string
  default = "default_project_name"
}
variable "vpc_id" {
  type = string
}
variable "az_count" {
  description = "Number of Availability Zones for subnets"
  type        = number
  default     = 3
}
variable "pub_sub_per_az_count" {
  description = "Number of public subnets per az."
  type        = number
}
variable "priv_sub_per_az_count" {
  description = "Number of private subnets."
  type        = number
}

