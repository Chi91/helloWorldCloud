# Create VPC using Terraform module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.14.0"

  name                    = var.name
  cidr                    = var.cidr
  azs                     = var.azs
  public_subnets          = var.public_subnets
  private_subnets         = var.private_subnets
  enable_nat_gateway      = var.enable_nat_gateway
  create_igw              = var.create_igw
  map_public_ip_on_launch = var.map_public_ip_on_launch

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

#Create EKS using Terraform module
module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.26.0"
  cluster_name                   = var.cluster_name
  subnet_ids                     = module.vpc.private_subnets
  vpc_id                         = module.vpc.vpc_id
  enable_irsa                    = true
  cluster_endpoint_public_access = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    eks_nodes = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t2.micro"]
      min_size       = "2"
      max_size       = "10"
      desired_size   = "3"
    }
  }
  
  cluster_additional_security_group_ids = [aws_security_group.eks_node_sg.id]
}

#Create security group for eks node
resource "aws_security_group" "eks_node_sg" {
  name   = "eks_node_sg"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "eks-node"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ingress_eks_node_sg" {
  security_group_id = aws_security_group.eks_node_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "egress_eks_node_sg" {
  security_group_id = aws_security_group.eks_node_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}


