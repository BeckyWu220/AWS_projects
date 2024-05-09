resource "kubernetes_namespace" "argocd" {
  depends_on = [ module.eks ]

  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  depends_on = [ module.eks ]

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace.argocd.metadata.0.name
  version    = "6.8.0"
  create_namespace = true
  timeout = 300
  set {
    name  = "server.service.type"
    value = "LoadBalancer"
  }
}

resource "kubernetes_namespace" "myapp" {
  depends_on = [ module.eks ]

  metadata {
    name = "myapp"
  }
}

resource "kubernetes_manifest" "argo_application" {
  depends_on = [ kubernetes_namespace.myapp, helm_release.argocd, module.eks ]
  provider = kubernetes

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "myapp-argo-application"
      namespace = "argocd"
    }
    spec = {
      project = "default"
      source = {
        repoURL         = var.git_repo_url
        targetRevision  = var.git_revision
        path            = var.git_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.myapp.metadata.0.name
      }
      syncPolicy = {
        syncOptions = ["CreateNamespace=true"]
        automated = {
          selfHeal = true
          prune    = true
        }
      }
    }
  }
}