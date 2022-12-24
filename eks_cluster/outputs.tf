output "endpoint" {
  value = aws_eks_cluster.main_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main_cluster.certificate_authority[0].data
}

output "name" {
  value = aws_eks_cluster.main_cluster.name
}

output "s3main_policy_arn" {
  value = aws_iam_role.s3main_oidc.arn
}

output "dynamodbmain_policy_arn" {
  value = aws_iam_role.dynamodbmain_oidc.arn
}
