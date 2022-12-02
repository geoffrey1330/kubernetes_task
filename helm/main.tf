provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.kubeconfig-certificate-authority-data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.cluster.outputs.name]
      command     = "aws"
    }
  }
}

resource "helm_release" "docker-2048" {
  name             = "docker-2048"
  chart            = "docker-2048"
  repository       = "./charts"
  namespace        = "docker-2048"
  max_history      = 3
  create_namespace = true
  wait             = true
  reset_values     = true
}
