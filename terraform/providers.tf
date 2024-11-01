terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.72.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.16.1"
    }
  }
}

data "aws_eks_cluster" "target" {
  depends_on = [module.eks]
  name       = var.cluster_name
}

data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  depends_on = [module.eks]
  name       = data.aws_eks_cluster.target.name
}

provider "aws" {
  region = "eu-central-1"
}

provider "kubernetes" {
  alias                  = "eks"
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

/* provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.aws_iam_authenticator.token
  }
} */

