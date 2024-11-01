# Use module to create a IAM Role
 module "irsa_cert_manager" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.41.0"

  create_role                   = true
  role_name                     = "cert-manager-iam-role"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [aws_iam_policy.cert_manager_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:cert-manager:cert-manager"]
} 

#Configure cert manager policy
resource "aws_iam_policy" "cert_manager_policy" {
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "acm:RequestCertificate",
          "acm:DescribeCertificate",
          "acm:ListCertificates",
          "acm:DeleteCertificate"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ],
        "Resource" : "*"
      }
    ]
  })
}


#Create Namespace for isolating 
resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

#Connect service account with IAM role
resource "kubernetes_service_account" "cert_manager" {
  metadata {
    name      = "cert-manager"
    namespace = "cert-manager"
    annotations = {
      "eks.amazonaws.com/role-arn" = module.irsa_cert_manager.iam_role_arn
    }
  }
}

#Install cert maanger with helm 
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = kubernetes_namespace.cert_manager.metadata[0].name
  version    = "v1.12.0"
  set {
    name  = "installCRDs"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "false" 
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.cert_manager.metadata[0].name
  }
}
