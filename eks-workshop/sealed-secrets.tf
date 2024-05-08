data "kubernetes_namespace" "kube-system" {
  metadata {
    name = "kube-system"
  }
}

resource "helm_release" "sealed_secrets" {
  name       = "sealed-secrets"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  namespace  =  data.kubernetes_namespace.kube-system.metadata.0.name
  version    = "2.15.3"  
  set {
    name  = "fullnameOverride"
    value = "sealed-secrets-controller"
  }
}