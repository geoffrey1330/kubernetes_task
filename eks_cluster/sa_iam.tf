######### Service Account 

### s3
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main_cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "s3main_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-s3main"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "s3main_oidc" {
  assume_role_policy = data.aws_iam_policy_document.s3main_oidc_assume_role_policy.json
  name               = "s3main-oidc"
}

resource "aws_iam_policy" "s3main-policy" {
  name = "s3main-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "s3:*"  
      ]
      Effect   = "Allow"
      Resource = "arn:aws:s3:::*"
    }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "s3main_attach" {
  role       = aws_iam_role.s3main_oidc.name
  policy_arn = aws_iam_policy.s3main-policy.arn
}

#### DynamoDB

data "aws_iam_policy_document" "dynamodbmain_oidc_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:aws-dynamodbmain"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "dynamodbmain_oidc" {
  assume_role_policy = data.aws_iam_policy_document.dynamodbmain_oidc_assume_role_policy.json
  name               = "dynamodbmain-oidc"
}

resource "aws_iam_policy" "dynamodbmain-policy" {
  name = "dynamodbmain-policy"

  policy = jsonencode({
    Statement = [{
      Action = [
        "dynamodb:*"    
      ]
      Effect   = "Allow"
      Resource = "arn:aws:dynamodb:::*"
    }
    ]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "dynamodbmain_attach" {
  role       = aws_iam_role.dynamodbmain_oidc.name
  policy_arn = aws_iam_policy.dynamodbmain-policy.arn
}
