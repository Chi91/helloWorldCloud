# Administrator Access
resource "aws_eks_access_entry" "Admin" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::597088016558:user/chi-normal"
  type          = "STANDARD"
}

resource "aws_eks_access_policy_association" "Admin" {
  cluster_name = module.eks.cluster_name
  # https://docs.aws.amazon.com/eks/latest/userguide/access-policies.html#access-policy-permissions
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = aws_eks_access_entry.Admin.principal_arn

  access_scope {
    type = "cluster"
  }
}