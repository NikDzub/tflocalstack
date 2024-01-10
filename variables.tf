variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
variable "ec2_inst_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}
