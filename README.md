## .

`cd tflocalstack`  
`terraform init`  
`terraform apply -var-file=./env_vars/dev.tfvars -auto-approve`

```s
./env_vars/dev.tfvars

project_name          = "dev"
az_count              = 2
pub_sub_per_az_count  = 1
priv_sub_per_az_count = 2
```

availability_zone_count : x  
public_subnets_per_availability_zone : ?  
private_subnets_per_availability_zone : ?

public_route_table_count : 1 (only one is needed)  
private_route_table_count : x (for each az)

nat_gateway_count : x (1 in each az, inside the (first\*)public subnet)

```s
$ terraform output

is_localstack = true

vpc_id = "vpc-ae447d14"

nat_gws = [
  {
    "nat_gw__name" = "nat_gw_az_1"
    "nat_gw_id" = "nat-38000d035a250b0f5"
    "public_ip" = "127.82.136.144"
    "subnet_id" = "subnet-a8f86f5d"
  },
  {
    "nat_gw__name" = "nat_gw_az_2"
    "nat_gw_id" = "nat-a54422f60fd7fec22"
    "public_ip" = "127.9.111.123"
    "subnet_id" = "subnet-711dc937"
  },
]
priv_route_tables = [
  {
    "private_table_id" = "rtb-cade61e7"
    "private_table_name" = "private_route_table_1"
  },
  {
    "private_table_id" = "rtb-d1d0d9f9"
    "private_table_name" = "private_route_table_2"
  },
]
priv_subs = [
  {
    "availability_zone" = "us-east-1a"
    "cidr" = "10.0.11.0/24"
    "subnet_id" = "subnet-3a8db6a5"
    "subnet_name" = "private_subnet_1"
  },
  {
    "availability_zone" = "us-east-1b"
    "cidr" = "10.0.12.0/24"
    "subnet_id" = "subnet-a3b3dd79"
    "subnet_name" = "private_subnet_2"
  },
  {
    "availability_zone" = "us-east-1a"
    "cidr" = "10.0.13.0/24"
    "subnet_id" = "subnet-f9fa107f"
    "subnet_name" = "private_subnet_3"
  },
  {
    "availability_zone" = "us-east-1b"
    "cidr" = "10.0.14.0/24"
    "subnet_id" = "subnet-9dcad2df"
    "subnet_name" = "private_subnet_4"
  },
]
pub_route_tables = [
  {
    "public_table_id" = "rtb-e1a807ae"
    "public_table_name" = "public_route_table_1"
  },
]
pub_subs = [
  {
    "availability_zone" = "us-east-1a"
    "cidr" = "10.0.1.0/24"
    "subnet_id" = "subnet-a8f86f5d"
    "subnet_name" = "public_subnet_1"
  },
  {
    "availability_zone" = "us-east-1b"
    "cidr" = "10.0.2.0/24"
    "subnet_id" = "subnet-711dc937"
    "subnet_name" = "public_subnet_2"
  },
]
```

to-do:  
1.change file structure  
/envs/dev/main.tf  
instead of running apply with the -var-file

2.figure a way to make security groups from a list  
while referencing one another id's in the 'inbound rules'???

3.add web servers, databases, load balancers, auto scaling, route53???

`https://github.com/antonbabenko/terraform-best-practices`  
`https://docs.localstack.cloud/user-guide/integrations/terraform/`  
`https://registry.terraform.io/browse/providers`  
`https://spacelift.io/blog/terraform-aws-vpc`  
`https://chat.openai.com/share/aa2511b5-6af5-4d25-8312-d0fe08fdd144`  
`awslocal ec2 describe-nat-gateways`  
`awslocal ec2 describe-vpcs`  
`terraform apply -var-file=./env_vars/dev.tfvars -auto-approve`  
`terraform destroy -auto-approve`  
`terraform plan -var-file=./env_vars/dev.tfvars`
