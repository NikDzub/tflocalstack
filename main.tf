provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = var.region
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    ec2 = "http://localhost:4566"
  }
}
resource "aws_instance" "ec2_inst" {
  ami           = "ami-0005e0cfe09cc9050"
  instance_type = var.ec2_inst_type
  tags = {
    Name = "ec2_inst"
  }
}
