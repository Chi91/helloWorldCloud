# Create VPC using Terraform Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.14.0"

  name                    = var.name
  cidr                    = var.cidr
  azs                     = var.asz
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  enable_nat_gateway      = var.enable_nat_gateway
  create_igw              = var.create_igw
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "20.26.0"
  cluster_name = var.cluster_name
  subnet_ids   = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id

  eks_managed_node_groups = {
    eks_nodes = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.micro"]
      min_size       = "2"
      max_size       = "10"
      desired_size   = "3"
    }
  }
}
