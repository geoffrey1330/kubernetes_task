data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket         = "israel-terraform"
    key            = "cluster.tfstate"
    region         = "us-east-1"
    dynamodb_table = "israel-dynamo-terraform"
  }
}

data "aws_caller_identity" "main" {}

data "aws_eks_cluster" "main" {
  name = data.terraform_remote_state.cluster.outputs.name
}


data "aws_eks_cluster_auth" "aws_iam_authenticator" {
  name = data.terraform_remote_state.cluster.outputs.name
}

data "aws_route53_zone" "main" {
  name = "israeltrello.be"
}
