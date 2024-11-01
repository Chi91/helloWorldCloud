region                  = "eu-central-1"
name                    = "chi-vpc"
cidr                    = "10.0.0.0/16"
azs                     = ["eu-central-1a", "eu-central-1b"]
public_subnets          = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets         = ["10.0.3.0/24", "10.0.4.0/24"]
enable_nat_gateway      = true
create_igw              = true
map_public_ip_on_launch = true


ami_type       = "ami-08ec94f928cf25a9d"
instance_types = ["t2.micro"]

cluster_name = "chi-cluster"