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

or use `awslocal`  
awslocal serves as a thin wrapper and a substitute for the standard aws command,  
enabling you to run AWS CLI commands within the LocalStack environment  
without specifying the --endpoint-url parameter or a profile.  
`pip install awscli-local`

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

## Networking / AWS notes

[EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html) = Elastic Compute Cloud,launch as many or as few virtual servers as you need, configure security and networking, and manage storage.

[VPC](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html) = Virtual Private Cloud, launch AWS resources in a logically isolated virtual network that you've defined. This virtual network closely resembles a traditional network that you'd operate in your own data center, After you create a VPC, you can add subnets.  
A VPC is an isolated portion of the AWS Cloud populated by AWS objects, such as Amazon EC2 instances.

[Subnet](https://docs.aws.amazon.com/vpc/latest/userguide/configure-subnets.html) = A subnet is a range of IP addresses in your VPC. You can create AWS resources, such as EC2 instances, in specific subnets.  
Each subnet must reside entirely within one Availability Zone and cannot span zones. By launching AWS resources in separate Availability Zones, you can protect your applications from the failure of a single Availability Zone.
You goota have subnets to launch resources in the vpc..

**Public subnet** – The subnet has a direct route to an internet gateway. Resources in a public subnet can access the public internet.

**Private subnet** – The subnet does not have a direct route to an internet gateway. Resources in a private subnet require a NAT device to access the public internet.

**VPN-only subnet** – The subnet has a route to a Site-to-Site VPN connection through a virtual private gateway. The subnet does not have a route to an internet gateway.

**Isolated subnet** – The subnet has no routes to destinations outside its VPC. Resources in an isolated subnet can only access or be accessed by other resources in the same VPC.

[Security groups](https://docs.aws.amazon.com/vpc/latest/userguide/default-security-group.html) = In AWS VPCs, AWS Security Groups act as virtual firewalls, controlling the traffic for one or more stacks (an instance or a set of instances). When a stack is launched, it's associated with one or more security groups, which determine what traffic is allowed to reach it

[NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) = A NAT gateway is a Network Address Translation (NAT) service. You can use a NAT gateway so that instances in a private subnet can connect to services outside your VPC but external services cannot initiate a connection with those instances.  
If you have resources in multiple Availability Zones and they share one NAT gateway, and if the NAT gateway’s Availability Zone is down, resources in the other Availability Zones lose internet access. To improve resiliency, create a NAT gateway in each Availability Zone, and configure your routing to ensure that resources use the NAT gateway in the same Availability Zone.

**Public (Default)**  
Instances in private subnets can connect to the internet through a public NAT gateway, but cannot receive unsolicited inbound connections from the internet. You create a public NAT gateway in a public subnet and must associate an elastic IP address with the NAT gateway at creation. You route traffic from the NAT gateway to the internet gateway for the VPC. Alternatively, you can use a public NAT gateway to connect to other VPCs or your on-premises network. In this case, you route traffic from the NAT gateway through a transit gateway or a virtual private gateway.

**Private**  
Instances in private subnets can connect to other VPCs or your on-premises network through a private NAT gateway. You can route traffic from the NAT gateway through a transit gateway or a virtual private gateway. You cannot associate an elastic IP address with a private NAT gateway. You can attach an internet gateway to a VPC with a private NAT gateway, but if you route traffic from the private NAT gateway to the internet gateway, the internet gateway drops the traffic.

Both private and public NAT gateways map the source private IPv4 address of the instances to the private IPv4 address of the NAT gateway, but in the case of a public NAT gateway, the internet gateway then maps the private IPv4 address of the public NAT Gateway to the Elastic IP address associated with the NAT Gateway. When sending response traffic to the instances, whether it's a public or private NAT gateway, the NAT gateway translates the address back to the original source IP address.

## Steps / notes

1. Create VPC with CIDR 10.0.0.0/16

2. Create Subnets in VPC  
   usualy 2 private 2public for diffrent az
   lets say CIDR 10.0.0.0/24 for public and 10.0.1.0/24 for private

3. Launch ec2 inst in the public subnet  
   chose a name, instance type, key-pair etc..  
   in network settings chose the VPC and the public subnet  
   because its a public sub enable 'auto assign public IP'  
   add a security group name

4. Allowing internet accsess to our subnets  
   create internet gateway and attach it to the vpc  
   now we need to give our subnet a route to the internet gateway with route tables

5. Create route table for our public and private subnet  
   we do have a default route table, and rn the 2 subnets are associated with it  
   because they dont have explicit associations.  
   create a route table (pub_route_table) and chose the vpc  
   create a route table (priv_route_table) and chose the vpc  
   then associate each one (now the default is mpty)

6. Route the public subnet to the internet gateway  
   go to pub_route_table and add route, dest = 0.0.0.0/0 target = igw  
   (now we have internet accses to the ec2 instance w ssh)  
   what about the

7. Launch ec2 inst in the private subnet
   chose a name, instance type, key-pair etc..  
   in network settings chose the VPC and the private subnet  
   add a security group name
   (we are able to ssh to the private ec2 from our public one
   but theres no internet acc to update pkgs for example.. NAT Gateway..
   )
