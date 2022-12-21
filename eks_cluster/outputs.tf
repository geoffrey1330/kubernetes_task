output "endpoint" {
  value = aws_eks_cluster.main_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main_cluster.certificate_authority[0].data
}

output "name" {
  value = aws_eks_cluster.main_cluster.name
}

output "main_policy_arn" {
  value = aws_iam_role.main_oidc.arn
}
