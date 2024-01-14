variable "vpc_id" {
  type = string
}
variable "az_count" {
  description = "Number of Availability Zones for subnets"
  type        = number
}
variable "igw" {
  description = "internet gateway"
}
