variable "region" {
  description = "region value"
  type        = string
  default     = "us-east-1"
}
variable "project_name" {
  description = "name of the project"
  type        = string
}
variable "vpc_cidr" {
  description = "vpc cidr"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_sub_az1_cidr" {}
variable "public_sub_az2_cidr" {}

variable "private_app_sub_az1_cidr" {}
variable "private_app_sub_az2_cidr" {}

variable "private_data_sub_az1_cidr" {}
variable "private_data_sub_az2_cidr" {}
