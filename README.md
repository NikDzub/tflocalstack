`https://docs.localstack.cloud/user-guide/integrations/terraform/`
`localstack config show`
`localstack config validate`
`localstack start`
`docker ps -a`
`localstack status services`
`localstack status docker`

## Ways to start LocalStack

start LocalStack with Docker Compose by configuring a docker-compose.yml file

```yml
version: "3.8"

services:
localstack:
container_name: "${LOCALSTACK_DOCKER_NAME:-localstack-main}"
    image: localstack/localstack
    ports:
      - "127.0.0.1:4566:4566"            # LocalStack Gateway
      - "127.0.0.1:4510-4559:4510-4559"  # external services port range
    environment:
      # LocalStack configuration: https://docs.localstack.cloud/references/configuration/
      - DEBUG=${DEBUG:-0}
volumes: - "${LOCALSTACK_VOLUME_DIR:-./volume}:/var/lib/localstack" - "/var/run/docker.sock:/var/run/docker.sock"
```

`docker-compose up`

start the LocalStack container using the Docker CLI instead of Docker-Compose

```r
docker run \
 --rm -it \
 -p 4566:4566 \
 -p 4510-4559:4510-4559 \
 localstack/localstack
```

or just `localstack start` who cares

## Ways to use AWS CLI

We can configure the AWS CLI to redirect AWS API requests to LocalStack  
by adding the `--endpoint-url=<localstack-url>` flag  
example : `aws --endpoint-url=http://localhost:4566 kinesis list-streams`

or edit `~/.aws/config` and `~/.aws/credentials` files to add our localstack profile

or use awslocal  
awslocal serves as a thin wrapper and a substitute for the standard aws command,  
enabling you to run AWS CLI commands within the LocalStack environment  
without specifying the --endpoint-url parameter or a profile.

## Project structure

```r
├── modules/                  # Terraform modules
│   ├── vpc/                  # VPC module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── subnets/              # Subnets module
│   │   ├── ...
│   ├── nat-gateway/          # NAT Gateway module
│   │   ├── ...
│   ├── rds/                  # RDS module
│   │   ├── ...
│   └── security-groups/      # Security groups module
│       ├── ...
│
├── environments/             # Separate configurations for each environment
│   ├── dev/                  # Development environment
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   ├── staging/              # Staging environment
│   │   └── ...
│   └── prod/                 # Production environment
│       └── ...
│
├── main.tf                   # Main Terraform configuration file
├── variables.tf              # Variable definitions
└── outputs.tf                # Output definitions
```

## Testing first applies

`./main.tf`

```s
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

```

running `terraform apply` first time to launch the instance

then `awslocal ec2 describe-instances` or `awslocal ec2 describe-instances --filters "Name=instance-type,Values=t2.micro" --query "Reservations[].Instances[].InstanceId"`  
(filters the list to only your t2.micro instances and outputs only the InstanceId values for each match.)

```s
[
    "i-ccdc7104da4b8c11e"
]
```
