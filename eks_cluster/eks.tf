### Cluster
resource "aws_eks_cluster" "main_cluster" {
  name     = "${var.env_code}-main-cluster"
  role_arn = aws_iam_role.main_role.arn

  vpc_config {
    subnet_ids = aws_subnet.public[*].id
  }
}


### Node Group
resource "aws_eks_node_group" "main_nodegroup" {
  cluster_name    = aws_eks_cluster.main_cluster.name
  node_group_name = "${var.env_code}-main_nodegroup"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = aws_subnet.public[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

}
