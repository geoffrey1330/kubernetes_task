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

resource "helm_release" "nginx_ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress"
  create_namespace = true

  provisioner "local-exec" {
    command = <<EOF
      echo "Waiting for the nginx ingress controller pods"
      kubectl wait --namespace ingress \
      --for=condition=ready pod \
      --selector=app.kubernetes.io/component=controller \
      --timeout=120s
      echo "Nginx ingress controller successfully started"
    EOF
  }
}

